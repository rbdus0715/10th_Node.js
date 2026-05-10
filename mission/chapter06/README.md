- 한 번에 여러 번의 DB 작업을 연달아 처리할 때, 중간에 처리가 실패했는데 DB에는 중간까지만 값이 반영되어 있으면 문제가 있을 것 같습니다. 이를 방지하는 기술로는 Transaction이 있는데, Prisma를 이용해 Transaction을 관리하는 방법을 찾아 정리해주세요. 워크북의 실습 프로젝트에서도 적용할 수 있다면 적용해주세요.
    
    # Nested writes
    
    관련있는 레코드들에 대한 여러 연산을 하나의 트랜잭션으로 수행하는 방법
    
    ```tsx
    // Create user with posts in a single transaction
    const user = await prisma.user.create({
      data: {
        email: "alice@prisma.io",
        posts: {
          create: [{ title: "Post 1" }, { title: "Post 2" }],
        },
      },
    });
    ```
    
    # Batch operations 배치 연산
    
    bulk operations을 트랜잭션으로 사용하는 방식
    
    - `createMany()` / `createManyAndReturn()`
    - `updateMany()` / `updateManyAndReturn()`
    - `deleteMany()`
    
    ```tsx
    const updateUsers = await prisma.user.updateMany({
      where: { email: { contains: "prisma.io" } },
      data: { role: "ADMIN" },
    });
    ```
    
    # $transaction API
    
    ### Sequential operations (독립적)
    
    실행할 쿼리들을 배열에 담아 전달하기
    
    ```tsx
    const [posts, totalPosts] = await prisma.$transaction([
      prisma.post.findMany({ where: { title: { contains: "prisma" } } }),
      prisma.post.count(),
    ]);
    ```
    
    아래처럼 옵션도 추가할 수 있다.
    
    ```tsx
    await prisma.$transaction(
      [prisma.resource.deleteMany({ where: { name: "name" } }), prisma.resource.createMany({ data })],
      { isolationLevel: Prisma.TransactionIsolationLevel.Serializable },
    );
    ```
    
    ### Interactive tarnsactions (의존적임)
    
    만약에 복잡한 서비스 로직 속에서 상호작용이 이뤄져야 하는 쿼리라면 interactive transactions를 사용한다.
    
    ```tsx
    const result = await prisma.$transaction(async (tx) => {
      const sender = await tx.account.update({
        data: { balance: { decrement: 100 } },
        where: { email: "alice@prisma.io" },
      });
    
      if (sender.balance < 0) {
        throw new Error("Insufficient funds");
      }
    
      return await tx.account.update({
        data: { balance: { increment: 100 } },
        where: { email: "bob@prisma.io" },
      });
    });
    
    // 물론 아래처럼 옵션도 추가 가능하다.
    await prisma.$transaction(
      async (tx) => {
        /* ... */
      },
      {
        maxWait: 5000, // Max wait to acquire transaction (default: 2000ms)
        timeout: 10000, // Max transaction run time (default: 5000ms)
        isolationLevel: Prisma.TransactionIsolationLevel.Serializable,
      },
    );
    ```
    
    ### 격리 수준 옵션
    
    여러 트랜잭션이 동시에 실행될 때 한 트랜잭션이 다른 트랜잭션에서 변경 중인 데이터를 
    어느정도까지 볼 수 있게 할지 결정하는 설정
    
    설정 방법은 아래와 같다.
    
    ```tsx
    await prisma.$transaction(
      async (tx) => {
        // 트랜잭션 로직
      },
      {
        isolationLevel: Prisma.TransactionIsolationLevel.Serializable, // 격리 수준 지정
      }
    );
    ```
    
    prism는 디비 엔진이 지원하는 표준 격리 수준 대부분을 지원한다.
    
    | read committed | 커밋된 데이터만 읽는다 - 다른 사람이 커밋했으면 트랜잭션 내에서도 바뀔 수 있음 |
    | --- | --- |
    | repeatable read | 트랜잭션 동안 읽은 데이터가 변하지 않음을 보장 |
    | serializable | 다른 트랜잭션이 데이터를 건드리지도 못하게 막음 |
- DB 성능은 서버 개발에서 가장 중요한 부분 중 하나입니다. Prisma를 이용해서 데이터베이스에 질의할 때, 각 SQL 쿼리가 얼마나 오래 소요되는지 로그를 남겨주세요. (쿼리를 실행하기 전의 시간을 측정하고, 쿼리를 실행한 이후의 시간을 측정하여 몇 ms가 소요되었는지 측정하여 `console.log`로 출력할 수 있습니다.) 가능하면 쿼리를 사용하는 부분마다 매번 `console.log`로 출력하기 보다는, 항상 공통으로 자동으로 적용될 수 있는 방법으로 구현해주세요.
    
    ```tsx
    export const prisma = base.$extends({
      query: {
        async $allOperations({
          operation,
          model,
          args,
          query,
        }: {
          model?: string;
          operation: string;
          args: unknown;
          query: (a: unknown) => Promise<unknown>;
        }) {
          const start = performance.now();
          const result = await query(args);
          const ms = performance.now() - start;
          const label = `${model ?? '?'}.${operation}`;
          console.log(`[${label}] ${ms.toFixed(2)}ms`);
          if (ms > 500) {
            console.warn(`Slow query: ${label} - ${ms.toFixed(2)}ms`);
          }
          return result;
        },
      },
    });
    ```
    
- 우리는 흔히 DB 쿼리에서 N+1 문제를 마주할 수 있습니다. 예를 들어, 게시글을 조회하면서 각 게시글에 해당하는 댓글들을 개별적으로 쿼리한다면, 댓글을 조회하는 쿼리가 각 게시글마다 추가로 발생하게 되어 N+1 문제가 발생합니다. 이를 Prisma에서 N+1문제를 해결할 수 있는 방법을 정리해주세요.
    
    ### N+1 문제란?
    
    쿼리 1번으로 끝날 것을 N번 더 실행해서 총 N+1번의 쿼리가 날아가는 현상
    
    사용자 10명을 조회하고, 각 사용자가 쓴 게시글 제목도 같이 보고 싶은 상황
    
    ```tsx
    // 1. 사용자 10명을 먼저 가져오기
    const users = await prisma.user.findMany({ take: 10 });
    
    // 2. 루프 돌며 사용자별 게시글 제목 쿼리 (N번)
    for (const user of users) {
      const posts = await prisma.post.findMany({
        where: { authorId: user.id }
      });
      console.log(`${user.name}의 글:`, posts);
    }
    ```
    
    ### 프리즈마 해결 방식
    
    ```tsx
    // 쿼리 딱 1~2번으로 끝냅니다.
    const usersWithPosts = await prisma.user.findMany({
      take: 10,
      include: {
        posts: true, // Prisma가 알아서 최적화해서 한 번에 가져옴
      },
      where: { authorId: user.id }
    });
    
    // 아니면 select
    const user = await prisma.user.findMany({
      select: {
        name: true,    
        posts: {      
          select: {
            title: true 
          }
        }
      },
    	where: { authorId: user.id }
    });
    
    ```
    
    - include나 select를 통해서 가능
    - 정확히는 1+1로 해결