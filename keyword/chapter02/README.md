- SQL 쿼리(CRUD, 필터링, 정렬, 제한, 집계 등 기본적인 SQL 문법을 정리해주세요)
    
    ### 1. DDL 데이터 정의
    
    - create
    
    ```sql
    CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,  -- 고유 번호 (자동 증가)
        name VARCHAR(50) NOT NULL,           -- 이름
        email VARCHAR(100) UNIQUE,           -- 이메일 (중복 불가)
        age INT,                             -- 나이
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 생성일
    );
    ```
    
    - alter
    - drop
    - rename
    - truncate
    
    ### 2. DML 데이터 조작
    
    - select
    - insert
    - update
    - delete
    
    데이터 생성
    
    ```sql
    INSERT INTO users (name, email, age) 
    VALUES ('홍길동', 'hong@example.com', 25);
    ```
    
    데이터 읽기 → 쿼리에서 자세히
    
    ```sql
    select *
    from users
    where age >= 20
    order by age desc
    limit 5;
    ```
    
    데이터 수정
    
    ```sql
    UPDATE users 
    SET name = '이순신', 
        email = 'lee@example.com', 
        age = 30 
    WHERE id = 1;
    
    ```
    
    데이터 삭제
    
    ```sql
    DELETE FROM members WHERE id = 5;
    ```
    
    코테 책 추천
    
    ![image.png](attachment:84a3eb46-1878-4fab-bee8-605aa25247af:image.png)
    
    ### 집계
    
    ```sql
    SELECT category, COUNT(*), AVG(price)
    FROM products
    GROUP BY category
    HAVING AVG(price) > 50000;
    ```
    
    → 카테고리로 그룹화해서 각 그룹에 대해 price 평균값이 50000 이상인 그룹만 출력
    
    → 이때 총 몇개인지와 평균값 출력
    
- 트랜잭션이란 무엇인가?
    
    # 트랜잭션
    
    의미: 쪼갤 수 없는 업무의 최소 단위
    
    - 여러 개의 작업을 하나로 묶어서 모두 성공하던가, 아니면 아예 아무것도 안 한 것처럼 되돌리던가!
    
    ![image.png](attachment:c509c10f-558c-44af-9148-487f118f6e30:image.png)
    
    # 트랜잭션 4가지 원칙 (ACID)
    
    - Atomicity 원자성 : 작업이 모두 성공하거나, 하나라도 실패하면 전부 취소 all or nothing
    - Consistency 일관성 : 트랜잭션 끝났을 때 디비 규칙은 절대 깨지지 않는다.
        - 잔액은 0원보다 작을 수 없다는 규칙
        
        ```sql
        create table accounts (
          id int primary key,
          balance int not null,
          constraint check_balance check (balance >= 0)
        );
        update accounts set balance = -500 where id =1;
        // 에러 발생 -> 트랜젝션 철회
        ```
        
    - Isolation 격리성 : 내가 작업하는 동안 남이 끼어들지 못하게 한다.
        - 기차표 예매 시 마지막 남은 1좌석
        - 격리성이 없다면 - 철수가 결제하는 도중(트랜젝션 진행중)에 영희 화면에도 예매 가능으로 떠서 둘 다 결제가 완료되는 대참사 발생
        - 철수가 결제 시작하는 순간 데이터베이스는 해당 좌석에 잠금 걸기 → 영희는 철수 결제가 완전 끝날때까지(commit) 기다리거나, 이미 판매된 좌석입니다라는 메시지 받음
        
        ```sql
        start transaction;
        
        // 특정 행을 내가 수정할거야!
        // 아무도 건들지 않도록 명시적 잠금 걸기
        select * from products where id = 101 for update;
        
        update products set stock = stock - 1 where id = 101;
        
        commit;
        ```
        
        <aside>
        
        ### 버스 좌석 선택할 때부터 트랜잭션 걸어야하나?
        
        좌석 선택 버튼을 누르는 순간부터 트랜잭션을 길게 유지하는 것은 아주 위험
        
        트랜잭션은 초 단위가 아닌, 밀리초 단위로 짧게 끝나야함
        
        만약 사용자가 좌석 클릭했을 때부터 트랜잭션이 시작되고, 결제 정보 입력하는 동안 5분이 지나면 계속 해당 행에 lock이 걸려있어 다른 사용자가 조회하거나 예약할 때 시스템이 느려짐
        
        DB에 연결된 통로 - connection 은 한정되어있는데, 결제중인 사용자들이 통로를 모두 점유하고 있으면 새로운 유저는 접속조자 못함
        
        ### 대신, 상태와 유효시간 사용
        
        ```sql
        update seats
        set status = 'selected',
            user_id = '홍길동',
            expire_at = now() + interval 5 minute
        where seat_no = 'A1' and status = 'available';
        ```
        
        </aside>
        
    - Durability 지속성 : 한 번 저장된 건 무슨일이 일어나도 남아있어야함
        - 결제 완료 후 데이터센터 정전되면?
        - 결제 이후 0.1 초 뒤 쇼핑몰 서버가 정전되어 서버가 꺼져도 주문 내역과 결제 기록은 그대로 남아있어야 함. 데이터베이스는 트랜잭션이 성공하면 로그를 디스크에 영구적으로 기록하기에 갑작스러운 고장에도 사라지지 않음
        
        ```sql
        // 트랜잭션 커밋될 때마다 로그를 디스크에 즉시 기록하도록 설정
        set global innodb_flush_log_at_trx_commit = 1;
        
        start transaction;
        inert into logs (msg) values ('작업완료');
        commit;
        ```
        
        <aside>
        
        ### 어짜피 트랜잭션 끝나면 로그 아니어도 디비에 잘 저장되는거 아닌가?
        
        진짜 데이터 파일 .ibd에 쓰는건 랜덤 디스크에 랜덤접근이므로 시간이 오래걸림.
        
        반면, 로그는 트랜잭션 commit 시에 바로 동시에 로깅이 남아 찰나에 순간에 서버가 꺼져도 기록이 남아 안전함.
        
        </aside>
        
    
    # 비관적 락과 낙관적 락
    
    여러 사람이 동시에 데이터를 수정하려고 할 때 발생하는 충돌을 해결하는 두 가지 전략
    
    ### 비관적 락 : 나 말고 누군가 분명히 이 데이터를 건드릴거야 (비관적)
    
    - 데이터를 읽을 때부터 아예 좌물쇠 걸어버림
    - 수정 마칠 때까지 다른 사람들은 데이터 읽거나 쓰지 못하고 줄서야함
    
    장점
    
    - 데이터 일관성 확실
    - 콘서트 예매 시 1명 제외한 나머지 99명은 DB 입구에서 순서대로 대기시킬 수 있음
    
    단점
    
    - **여러명 접속 시 대기시간 길어져 성능 저하**
    - 서로 비키라고 싸우는 데드락 발생 위험
    
    ```tsx
    await connection.beginTransaction();
    
    try {
        // 1. 조회할 때 바로 문을 잠금 (FOR UPDATE)
        // 먼저 온 A가 이 쿼리를 실행하면, 뒤늦게 온 B는 여기서 대기(Wait)합니다.
        const [seat] = await connection.query(
            'SELECT * FROM seats WHERE id = ? FOR UPDATE', 
            [seatId]
        );
    
        if (seat.status === 'AVAILABLE') {
            // 2. 좌석 업데이트 (A가 안전하게 수정)
            await connection.query('UPDATE seats SET status = "RESERVED" WHERE id = ?', [seatId]);
    
            // 3. 예약 정보 저장
            await connection.query('INSERT INTO reservations (user_id, seat_id) VALUES (?, ?)', [userId, seatId]);
            
            await connection.commit(); // A가 커밋하면 그제야 대기하던 B가 1번부터 실행함
        } else {
            await connection.rollback(); // B는 들어와보니 이미 'RESERVED'라 여기서 끝남
        }
    } catch (err) {
        await connection.rollback();
    }
    ```
    
    ### 낙관적 락 : 설마 나를 동시에 수정하겠어? 라고 생각
    
    장점
    
    - 실제 락을 걸지 않아 성능 빠르고 동시 처리 유리
    - 일반적인 블로그 글에서 사용
    
    단점
    
    - 동시 수정이 많이 일어나면 실패 처리가 잦아져 재시도 로직을 직접 짜야 하는 번거로움
    - 동시에 100명이 누르면 1명만 성공하고 99명은 에러 → 실패한 유저 -  재시도 로직 구현
    - 인기 콘서트처럼 무조건 충돌나는 상황이라면 실패한 99명이 다시 조회하고 요청하는 과정이 더 큰 부담줄 수 있음
    
    ```sql
    CREATE TABLE seats (
        id INT PRIMARY KEY,
        status VARCHAR(20), -- 'AVAILABLE' (예약가능), 'RESERVED' (예약됨)
        version INT DEFAULT 0 -- 수정 횟수 기록용
    );
    ```
    
    ```tsx
    async function reserveSeat(seatId, userId) {
        // 데이터 읽어오기 (락 X)
        const [rows] = await connection.query(
            'SELECT id, status, version FROM seats WHERE id = ?', [seatId]
        );
        const seat = rows[0];
        const currentVersion = seat.version; // 내가 읽은 시점의 버전 (예: 1)
    
        if (seat.status !== 'AVAILABLE') return "이미 예약됨";
    
        // 업데이트 시도: "내가 읽었을 때 버전이 1이었는데, 지금도 1이면 2로 수정"
        const [result] = await connection.query(
            `UPDATE seats 
             SET status = 'RESERVED', version = version + 1 
             WHERE id = ? AND version = ?`, 
            [seatId, currentVersion]
        );
    
        if (result.affectedRows === 0) {
            // 내가 UPDATE 버튼을 누르기 직전에 누군가 먼저 version을 2로 바꿔버린 상황
            throw new Error("낙관적 락 충돌: 다른 사람이 먼저 예약했습니다.");
        }
    
        // 성공 시 예약 확정 저장
        await connection.query('INSERT INTO reservations ...');
        return "예약 성공";
    }
    
    ```
    
    쉽게 말하면 눈치게임
    
    - A: 어? 1번 좌석 비었다. 버전이 10이네? 오케이
    - B: 어? 1번 좌석 비었다. 버전이 10이네? 오케이
    - A: 내가 잡아야지! 버전 10인 1번 좌석 내가 잡았으니깐 1번 좌석 데이터 수정해두고,
    버전은 10 + 1로 바꿔놔야겠다.
    - B: 내가 잡아야지! 버전 10인 1번 좌석 수정… 어? 없네? → **낙관적 락 충돌**
    
    # 레디스 분산 락
    
    (챕터 1에서 더블클릭 문제에서도 언급)
    
    - 디비 입구까지 오기도 전에 레디스에서 입구컷 해주는 방식
    - 실제 수만명이 몰리는 티켓팅 서비스에서 가장 많이 사용
    
    DB는 하드디스크에 저장하느라 느리고, 연결할 수 있는 인원이 한정적임
    
    레디스는 메모리 기반이라 1초에 수십만 번 작업 처리 가능
    
    방식
    
    1. 락획득
        - locks:seat:123 열쇠를 레디스에 생성
        - 1초동안 유효하고, 만약 다른 요청이 동시에 들어오면, 레디스에 이미 키가 있음을 확인하고 에러 던져 중복 진입 차단
    2. 안전 구역
        - 실제 디비 데이터 조회 및 수정
        - 락을 획득한 단 한명의 프로세스만 이 구간 실행
    3. 자동 보호 및 해제
        - lock.release
        - 작업이 끝나면 열쇠 반납해 다음 사람이 예약할 수 있게 함
        - 디비 작업 중 서벅 ㅏ다운되어 해제 코드가 실행되지 않아도, 처음 1초로 설정했기 때문에 자동 삭제되어 데드락 현상도 방지
    
    ```sql
    const Redlock = require('redlock');
    const redlock = new Redlock([redisClient]);
    
    async function reserveSeat(seatId, userId) {
        const lockKey = `locks:seat:${seatId}`; // 좌석별 고유 키
        
        try {
            // 1. Redis에서 1초 동안 유지되는 락 획득 시도
            const lock = await redlock.acquire([lockKey], 1000);
    
            // --- 여기서부터는 안전 구역 (오직 한 명만 들어옴) ---
            // 2. 실제 DB 작업 (조회 -> 저장)
            const seat = await db.query('SELECT * FROM seats WHERE id = ?', [seatId]);
            if (seat.status === 'AVAILABLE') {
                await db.query('UPDATE seats SET status = "RESERVED" ...');
                await db.query('INSERT INTO reservations ...');
            }
            // ----------------------------------------------
    
            // 3. 작업 끝났으니 락 해제
            await lock.release();
            return "예약 성공!";
    
        } catch (err) {
            // 락 획득 실패 시 (이미 누군가 잡고 있음)
            return "이미 다른 사람이 예약 중입니다.";
        }
    }
    
    ```
    
- 인덱스(Index)란?
    
    # MySQL 내부 작동 원리와 병목 원인
    
    ![image.png](attachment:78a813fb-3fda-4d76-866b-b0f49ec3b881:image.png)
    
    - 옵티마이저 : 파싱된 SQL문 분석, 빠르게 데이터 가져올 수 있도록 계획 세움
        - 어떤 순서로 테이블 접근? 인덱스 사용할까? 어떤 인덱스 사용하지 등
        - 옵테이마이저의 이 계획은 완벽하지 않을 수 있어 SQL 튜닝 필요
    - 스토리지엔진 - 데이터 가져오기 : 대부분 여기에서 병목
        - **데이터를 찾는데 너무 오래걸리거나**
        - **불러올 데이터가 너무 많음!!**
    
    # 인덱스란?
    
    https://www.youtube.com/watch?v=VvYh8HBM0A8&list=PLtUgHNmvcs6rJBDOBnkDlmMFkLf-4XVl3&index=6
    
    https://mangkyu.tistory.com/96
    
    어렵게 말하면 
    
    - **추가적인 쓰기 작업과 저장공간을 활용해 디비 테이블의 검색 속도를 향상시키는 자료구조**
    
    쉽게 말하면 
    
    - **데이터를 빨리 찾기 위해 특정 칼럼을 기준으로 미리 정렬해놓은 표**
    
    ![image.png](attachment:99066d1b-dba8-4589-81d7-4b0ec81dc959:image.png)
    
    ![image.png](attachment:8aadff6a-b1ab-4c81-9e39-3b3b3aee1cc7:image.png)
    
    → 나이가 23살인 유저 빠르게 찾기 위해 나이순으로 정렬된 표를 미리 만들어둔다!
    
    인덱스 사용하면 update, delete 성능도 좋아짐. → 일단 찾아야 작업할 수 있기 때문
    
    인덱싱 장단점
    
    - 장점
        - 테이블 조회 속도, 성능 향상
        - 전반적 시스템 부하 감소
    - 단점
        - 인덱스 관리를 위해 약 10% 저장공간 별도 필요
        - 인덱스 관리 추가작업 필요
        - 인덱스 잘못 사용하면 오히려 성능 저하
    
    <aside>
    
    ### 인덱스 성능 저하시키는 원인
    
    delete, update 연산은 기존 인덱스를 삭제하지 않고 사용하지 않음 처리를 하기 때문에
    
    update, delete가 빈번하게 사용되면, 실제 데이터보다 훨씬 더 많은 인덱스가 존재하게됨
    
    ### 인덱스 사용하면 좋은 경우
    
    - 규모가 작지 않은 테이블
    - insert, update, delete가 자주 발생하지 않는 칼럼
    - join, where, order by 에 자주 사용되는 칼럼
    - 데이터 중복도 낮은 칼럼
    </aside>
    
    # 인덱싱 직접 해보고 성능 측정
    
    ## # good case
    
    측정 전에 먼저 mysql 조회 개수 제한 풀기
    
    ![image.png](attachment:6a3c0619-ff09-42e1-a724-8f778ba588e7:image.png)
    
    ```sql
    -- 테이블 생성
    create table user (
        id int auto_increment primary key,
        name varchar(100),
        age int
    );
    
    select * from user;
    
    -- 더미데이터 생성
    SET SESSION cte_max_recursion_depth = 1000001;
    
    insert into user(name, age)
    with recursive cte(n) as (
        select 1
        union all
        select n + 1 from cte where n < 1000000
    )
    select
        concat ('user', LPAD(n, 7, '0')),
        floor(1+ rand() * 1000) as age
    from cte;
    
    -- 나이 23살인 유저 조회
    select * from user where age = 23;
    ```
    
    ![image.png](attachment:73642b4f-759a-4ffe-bbf8-7aa0a402a94f:image.png)
    
    ```sql
    create index idx_age on user(age);
    show index from user;
    
    select * from user where age = 23;`
    ```
    
    ![image.png](attachment:e37fbc74-8b5f-4aa8-897b-6a2bca340f8f:image.png)
    
    해당 테이블의 인덱스 확인해보면 PK는 기본적으로 생성되는 인덱스이고,
    
    내가 생성한 idx_age도 확인 가능하다.
    
    ![image.png](attachment:35f6591f-0db7-494d-a57e-c0a8c232fbef:image.png)
    
    말했듯이 PK는 자동적으로 생성되는 인덱스이고,
    
    유니크 제약을 사용한 컬럼에는 자동적으로 인덱스가 만들어진다는 것도 기억하자.
    
    ## # bad case
    
    - 코드
        
        ```sql
        create table table_no_index (
            id int auto_increment primary key,
            col1 int,
            col2 int,
            col3 int,
            col4 int,
            col5 int,
            col6 int,
            col7 int,
            col8 int,
            col9 int,
            col10 int
        );
        
        create table table_with_index (
            id int auto_increment primary key,
            col1 int,
            col2 int,
            col3 int,
            col4 int,
            col5 int,
            col6 int,
            col7 int,
            col8 int,
            col9 int,
            col10 int
        );
        create index idx_col1 on table_with_index(col1);
        create index idx_col2 on table_with_index(col2);
        create index idx_col3 on table_with_index(col3);
        create index idx_col4 on table_with_index(col4);
        create index idx_col5 on table_with_index(col5);
        create index idx_col6 on table_with_index(col6);
        create index idx_col7 on table_with_index(col7);
        create index idx_col8 on table_with_index(col8);
        create index idx_col9 on table_with_index(col9);
        create index idx_col10 on table_with_index(col10);
        
        set session cte_max_recursion_depth = 100000;
        
        insert into table_no_index(col1, col2, col3, col4, col5, col6, col7, col8, col9, col10)
        with recursive cte as(
            select 1 as n
            union all
            select n + 1 from cte where n < 100000
        )
        select
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000)
        from cte;
        
        insert into table_with_index(col1, col2, col3, col4, col5, col6, col7, col8, col9, col10)
        with recursive cte as(
            select 1 as n
            union all
            select n + 1 from cte where n < 100000
        )
        select
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000),
            floor(rand() * 1000)
        from cte;
        ```
        
    
    인덱스 없는 테이블 → 대략 600ms
    
    ![image.png](attachment:5b6e5fd1-c872-48b5-9dad-c23690abc8b7:image.png)
    
    모든 컬럼에 인덱스 건 테이블 → 3s 380ms
    
    ![image.png](attachment:df470e9f-2120-4ade-9020-bbdf1f860862:image.png)
    
- ORM VS Raw SQL 의 차이를 정리하고 유명한 ORM을 정리해주세요
    
    # ORM, Raw SQL
    
    db
    
    - mysql https://github.com/mysql/mysql-server
    - postgrdsql https://github.com/postgres/postgres
    
    orm
    
    - prisma https://github.com/prisma/prisma
    - typeorm https://github.com/typeorm/typeorm
    
    |  | **ORM (Object-Relational Mapping)** | **Raw SQL (원시 SQL)** |
    | --- | --- | --- |
    | **정의** | 객체 지향 언어의 객체와 DB 데이터를 자동으로 매핑 | DB에 직접 전달하는 구조화된 쿼리 언어 자체 |
    | **방식** | 코드(함수/메서드)로 데이터 조작 | SQL 문법을 문자열 형태로 직접 작성 |
    | **생산성** | **높음.** CRUD 작업이 간결하고 빠름 | **낮음.** 중복 코드가 발생하기 쉬움 |
    | **성능** | **상대적 낮음.** 내부 변환 과정을 거침 | **높음.** 최적화된 쿼리 실행 가능 |
    | **보안** | SQL 인젝션 방어에 유리 | 수동으로 파라미터 바인딩 필요 |
    
    # 성능 벤치마킹
    
    - https://github.com/Specticall/prisma-vs-sql-research
    
    컨테이너 환경에서 15가지 연관된 테이블로 postgresql 에서 Rawsql과 프리즈마 orm 성능을 비교
    
    주요 성능 지표
    
    - cpu 사용률, 메모리 소비, 쿼리 실행 시간, 전바적인 시스템 안전성
    
    실험 결과, RawSQL이 모든 지표에서 훨씬 뛰어남 → 당연한 것
    
    - 실행 속도는 5배
    - cpu는 6~9배
    - 메모리는 2~3배 적게
    
    성능이 민감한 곳에서 prisma는 상당한 오버헤드를 가짐
    
    # 유명한 orm
    
    nodejs
    
    - prisma
    - typeORM
    - sequalize
    
    java
    
    - jpa
    - hibernate
    
    python
    
    - sqlalchemy
    - django orm