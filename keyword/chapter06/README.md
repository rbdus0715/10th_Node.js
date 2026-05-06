- ORM
    
    ### ORM
    
    - ORM(Object-Relational Mapping, 객체 관계 매핑)
    - 객체 지향 프로그래밍(OOP)의 객체와 관계형 데이터베이스(RDB)의 테이블을 
    자동으로 연결(매핑)해주는 기술
    
    연결이 어떻게 이뤄지나?
    
    - 클래스 ↔  테이블
    - 객체 ↔ 행
    - 속성 ↔ 열
    
    애초에 객체지향과 DB는 설계 사상이 다르기 때문에 orm이 사이에서 연결해줌
    
- Prisma 문서 살펴보기
    - ex. Prisma의 Connection Pool 관리 방법
        
        ```tsx
        DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public&connection_limit=10"
        ```
        
        ```tsx
        import { PrismaClient } from '@prisma/client'
        
        const prisma = new PrismaClient()
        export default prisma;
        ```
        
        ### 어댑터를 통해 코드 레밸에서 커넥션 풀 설정 가능
        
        ```bash
        npm install @prisma/client @prisma/adapter-mariadb mariadb
        ```
        
        ```tsx
        import { PrismaClient } from '@prisma/client'
        import { PrismaMariaDb } from '@prisma/adapter-mariadb'
        import mariadb from 'mariadb'
        
        const pool = mariadb.createPool({
          host: process.env.DB_HOST,
          user: process.env.DB_USER,
          password: process.env.DB_PASSWORD,
          database: process.env.DB_NAME,
          connectionLimit: 20,      // 동시에 유지할 최대 연결 수
          connectTimeout: 10000,    // 연결 타임아웃 (ms)
          idleTimeout: 60000        // 유휴 연결 유지 시간
        })
        
        const adapter = new PrismaMariaDb(pool)
        const prisma = new PrismaClient({ adapter })
        ```
        
    - ex. Prisma의 Migration 관리 방법
        
        ### migraion
        
        데이터스키마 변경 사항을 코드 수준에서 추적하고 적용하는 버전 관리 도구
        
        ![image.png](attachment:627f9987-cec6-4e26-b817-d4fefc41c0cd:image.png)
        
        ### 개발환경
        
        개발 댄계에서는 스키마 자유롭게 수정하고 즉시 데이터베이스에 반영한다.
        
        - npx prisma migrate dev —name <이름>
        - schema.prisma 변경 사항을 감지해 prisma/migrations 폴 내에 .sql 형태로 기록
        
        ### 운영환경
        
        - npx prisma migrate dep
        
        생성된 마이그레이션 파일을 디비에 적용만 함 - 데이터 삭제 방지
        
        ### 디비 초기화
        
        - npx prisma migrate reset
- ORM(Prisma)을 사용하여 좋은 점과 나쁜 점
    
    ### 장점
    
    - 높은 생산성, 가독성
    - 유지보수 유지성
    - DB 추상화 - 특정 디비 엔진에 종속되지 않음
    - 타입스크립트와 결합 시 디비 구조에 맞는 타입 추론 가능 → 오타, 잘못된 필드 접근을 컴파일 타임에 알 수 있음
    
    ### 단점
    
    - 내부적으로 sql을 생성하는 과정에서 오버헤드 발생 가능
    - 통계 쿼리, 복잡한 join, union 등 세밀한 쿼리 시 orm만으로는 한계가 있는 경우 raw query 사용
    - 초기 학습 곡선
    - N+1 문제 → 시니어 미션
- 다양한 ORM 라이브러리 살펴보기
    
    # TypeORM
    
    - code first ORM
        - 엔티티 클래스를 작성하고 데이터베이스와 매핑
    - 데코레이터 기반의 객체 지향(OOP) ORM
    - Java의 Hibernate나 Python의 SQLAlchemy와 스타일이 비슷
    - Prisma와 가장 큰 차이점: class 기반으로 DB 테이블 정의
    
    ```tsx
    import { Entity, PrimaryGeneratedColumn, Column } from "typeorm"
    
    @Entity()
    export class User {
        @PrimaryGeneratedColumn()
        id: number
    
        @Column()
        firstName: string
    
        @Column()
        lastName: string
    
        @Column()
        isActive: boolean
    }
    ```
    
    ```tsx
    import "reflect-metadata";
    import { DataSource } from "typeorm";
    import { User } from "./entity/User"; 
    
    export const AppDataSource = new DataSource({
        type: "mysql",          
        host: "localhost",     
        port: 3306,
        username: "your_user",
        password: "your_password",
        database: "test_db",
        synchronize: true,      
        logging: true,       
        entities: [User], 
        migrations: [],
        subscribers: [],
    });
    
    ```
    
    ```tsx
    import express from "express";
    import { AppDataSource } from "./data-source";
    import { User } from "./entity/User";
    
    const app = express();
    app.use(express.json());
    
    AppDataSource.initialize()
        .then(() => {
            console.log("Data Source has been initialized!");
            app.listen(3000, () => console.log("Server is running on port 3000"));
        })
        .catch((err) => {
            console.error("Error during Data Source initialization", err);
        });
    ```
    
    ```tsx
    import { AppDataSource } from "./data-source";
    import { User } from "./entity/User";
    
    const userRepository = AppDataSource.getRepository(User);
    const users = await userRepository.find();
    
    ```
    
    ### prisma 쿼리 비교 - 간단한 select
    
    ```tsx
    // TypeORM
    const posts = await postRepository.find({
      where: { published: true },
      select: {
        id: true,
        title: true
      }
    });
    
    // Prisma
    const posts = await prisma.post.findMany({
      where: { published: true },
      select: {
        id: true,
        title: true
      }
    });
    ```
    
    ### 쿼리 작동 방식의 차이점
    
    ```tsx
    // TypeORM
    const posts = await postRepository.find({
      where: { published: true },
      relations: {
        author: true
      }
    });
    
    // Prisma
    const posts = await prisma.post.findMany({
      where: { published: true },
      include: {
        author: true
      }
    });
    ```
    
    - typeORM relation 옵션: 하나의 큰 left join 쿼리
        - 장점: DB를 한번만 다녀옴 → 네트워크 라운드 트립 적음
        - 단점: 데이터 양 많아지면 결과 셋 거대해짐
        
        → DB 사양이 중요
        
    
    prisma 1+1 (batch query) 방식
    
    - select * from post … 로 post 먼저 가져옴
    - 가져온 게시글 중 authorId만 뽑아 중복 제거
    - select * from user where id in (작성자 id 리스트)
    
    → 쿼리 단순해져서 디비 부담 적음, 다만 네트워크 거리가 중요
    
    https://velog.io/@intellik/TypeORM%EA%B3%BC-Prisma-%EB%B9%84%EA%B5%90%ED%95%98%EA%B8%B0
    
- 페이지네이션을 사용하는 다른 API 찾아보기
    - 오프셋 기반 페이지네이션 ex. https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api?apiVersion=2022-11-28
        
        https://docs.stripe.com/api/pagination
        
    - 커서 기반 페이지네이션 ex. https://developers.notion.com/reference/intro#pagination
        
        https://ignaciochiazzo.medium.com/paginating-requests-in-apis-d4883d4c1c4c
        
        https://docs.slack.dev/apis/web-api/pagination/
        
    
    ![image.png](attachment:45d949e1-c759-4854-be06-73bdc45d6586:image.png)