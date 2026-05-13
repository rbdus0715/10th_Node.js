- 미들웨어
    
    ### 미들웨어
    
    서로 다른 애플리케이션, 네트워크 사이에서 양측 연결해 데이터 주고받을 수 있도록 중간 매게 역할
    
    ### Expres에서 미들웨어
    
    - 클라이언트 요청과 서버 응답 사이에서 실행하는 함수
    
    동작 방식: 들어온 요청 변형하거나 유효성 검사 후 next() 함수를 호출해 다음 순서의 미들웨어로 제어권 넘겨주는 것
    
    실제 운영 환경에서 미들웨어 구조 잘못 설계하면 응답시간 엄청 증가한다고 합니다…
    
    ### 내부 동작 원리
    
    ![image.png](attachment:51fa5106-b6f0-408e-a534-4452542e8907:image.png)
    
    express 미들웨어는 내부적으로 체인 구조를 따릅니다.
    
    http 요청 → express가 등록된 미들웨어 → req, res 수정 등 동작 → next() 호출
    
    → 다음 미들웨어 실행 → 마지막까지 가면 라우터 실행 → 클라이언트 반환
    
    ### 커스텀 미들웨어 만들기
    
    미들웨어 함수는 일반적으로 3가지 메개변수를 받습니다.
    
    ```cpp
    const middleware = (req, res, next) => {
    	// 미들웨어 처리 로직
    	console.log('middleware execution')
    	// 다음 메들웨어로 제어 이동
    	next();
    	// 후처리 로직 (응답 완료 후 실행되는 부분)
    	console.log('응답 완료');
    }
    ```
    
    에러 처리 미들웨어의 경우는 이전 단계에서 발생해 전달된 에러 객체를 err 매개변수로 받습니다.
    
    ```cpp
    // 일반 라우터에서 에러 발생 시 next로 전달
    app.get('/data', (req, res, next) => {
      try {
        // 에러 강제 발생
        throw new Error('데이터를 불러오지 못했습니다.');
      } catch (error) {
        next(error); // 인자를 넣으면 에러 처리 미들웨어의 err 변수로 연결됨
      }
    });
    
    // 최하단에 위치한 글로벌 에러 처리 미들웨어
    app.use((err, req, res, next) => {
      console.error(err.message); // '데이터를 불러오지 못했습니다.' 출력
      
      res.status(err.status || 500).json({
        success: false,
        message: err.message
      });
    });
    
    ```
    
    https://notavoid.tistory.com/126
    
- HTTP 상태 코드
    
    클라이언트가 보낸 요청이 실패했는지 성공했는지 서버에서 알려주는 숫자 코드
    
    3자리 숫자로 이루어져있으며 100~500번대까지 존재
    
    - 100 : 요청이 수신디어 처리중 → 잘 사용되지 않음
    - 200 : 정상 처리
        - 201 정상 처리 및 새 리소스 생김
        - 202 서버가 아직 처리 완료하지 못해서 일단 알았다는 표시~ (요청이 크고 무거움)
    - 300 : 요청 완료를 위해 추가 행동 필요
        - 301 영구적으로 특정 페이지로 리다이렉션
        - 302 임시적으로 다른 주소로 보낼 때 사용
    - 400 : 클라이언트 오류, 잘못된 문법 등으로 서버가 요청을 수행할 수 없음
        - 400 bad request 클라이언트의 잘못된 요청 구문, 문법 오류
        - 401 unauthorized 인증이 수행되지 않아 수행 불가함을 의미
        - 403 forbidden 승인되지 않아 작업을 진행할 수 없음. 로그인은 했지만 회원 등급으로 인해 접근 권한 불충분 → production에서는 404로 처리하기
        - 404 not found 클라이언트가 요청한 자원이 존재하지 않음
    - 500 : 서버 오류
        - 500 서버 내부 문제
        - 502 게이트웨이가 잘못되어 통신 장애 발생한 경우
        - 503 서비스 일시적으로 이용 불가
    
    https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Status
    
- 에러 핸들링(Error Handling)
    
    보통 express에서 에러 처리 미들웨어로 전역에서 일괄 관리하는 것이 가장 효율적입니다.
    
    ```cpp
    app.use((err, req, res, next) => {
      console.error(err.stack);
    
      const statusCode = err.statusCode || 500; 
      
      res.status(statusCode).json({
        success: false,
        message: err.message || '서버 내부 오류가 발생했습니다.', 
      });
    });
    ```
    
    라우터에서 에러 전달해서 전역으로 전달하려면 단순하게 new Error를 던지면 됩니다.
    
    next() 호출하지 않아도 익스프레스에서 자동으로 잡아서 글로벌 에러 핸들러로 넘겨줍니다.
    
    ```cpp
    throw new Error('에러!')
    ```
    
    setTimeout, Promise, async/await 등 비동기 코드에서 발생한 에러는 Express가 자동으로 잡지 못하기 때문에
    
    next(err)를 통해 명시적으로 넘겨주면 됩니다.
    
    ```cpp
    app.get('/async-error', async (req, res, next) => {
      try {
        const data = await DB.findUser(); // 비동기
        if (!data) {
          const error = new Error('유저를 찾을 수 없습니다.');
          error.statusCode = 404;
          return next(error); 
        }
        res.json(data);
      } catch (err) {
        next(err); 
      }
    });
    
    ```
    
    근데 단순하게 Error 객체를 전달하는 것보다 각각의 상황에 맞게 커스텀해서 에러를 전달하는 것이 좋습니다.
    
    아래 형태로 커스텀 에러 객체를 만들수 있습니다.
    
    ```cpp
    class AppError extends Error {
      constructor(message, statusCode) {
        super(message);
        this.statusCode = statusCode;
        Error.captureStackTrace(this, this.constructor); 
      }
    }
    
    app.get('/premium-content', (req, res, next) => {
      const isPremiumUser = false;
      if (!isPremiumUser) {
        return next(new AppError('프리미엄 회원만 접근 가능합니다.', 403));
      }
    });
    
    ```
    
- Tsoa
    
    ![image.png](attachment:9ec786e6-4100-4a08-9de6-276bfa4f8489:image.png)
    
    ### tsoa?
    
    typescript와 nodejs 환경에서 컨트롤러 코드를 정적 분석해서 OpenAPI 스펙(swagger) 문서와 라우팅 코드를 자동으로 생성해주는 컴파일러
    
    장점 → 개발자가 스웨거 문서 작성해야하는 번거로움 해결, 코드와 문서 불일치 문제 방지!
    
    참고로 openAPI 스펙은 restful 웹 서비스를 정해진 표준 규칙에 따라 json/yaml 형식으로 표현하는 디자인 정의 방법 표준임
    
    tsoa 안하면…
    
    ```yaml
    openapi: 3.1.0 # 사용할 OpenAPI의 버전 고시
    info: # API의 제목, 설명, 버전 등의 메타데이터
      title: User API
      version: 1.0.0
    servers: # API가 호스팅되는 서버들의 URL 위치
      - url: example.com
    paths: # 실제 API 엔드포인트와 HTTP 메서드 정의
      /users/{id}:
        get:
          summary: 사용자 정보 조회
          parameters:
            - name: id
              in: path
              required: true
              schema:
                type: integer
          responses:
            '200':
              description: 성공
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/User'
    components: # 응답 모델이나 보안 스키마 등 재사용 가능한 요소 정의
      schemas:
        User:
          type: object
          properties:
            id:
              type: integer
            name:
              type: string
    
    ```
    
    위 yaml 파일 직접 다 작성해야합니다…
    
    대신 이렇게
    
    ```tsx
    @Tags('User')          // Swagger UI에서 보여질 그룹 태그
    @Route('api/users')    // 기본 엔드포인트 경로 (예: /api/users)
    export class UserController extends Controller {
    }
    ```
    
    ```tsx
    @Tags('User')
    @Route('api/users')
    export class UserController extends Controller {
    
      @Get('{userId}') // GET /api/users/123
      public async getUser(
        @Path() userId: number,              // URL 경로 변수 (자동 타입 변환)
        @Query() search?: string             // 쿼리 스트링 (?search=abc)
      ): Promise<UserResponse> {
        return { id: userId, name: '홍길동', status: 'active' };
      }
    
      @SuccessResponse('201', 'Created')     // 성공 시 반환 코드 설정
      @Post()          // POST /api/users
      public async createUser(
        @Body() requestBody: UserCreationParams // HTTP Body (JSON 데이터)
      ): Promise<void> {
        this.setStatus(201); // 응답 상태코드 변경
        // 유저 생성 로직
        return;
      }
    }
    
    ```