- 환경 변수
    
    ## 환경변수
    
    애플리케이션이 실행되는 환경에서 설정하는 동적인 key-value 형태의 정보로, 코드 상에 직접 정보를 넣지 않고 외부에서 설정하는 방식이다.
    
    환경변수 사용하여 보안을 강화하고, 환경별 설정을 다르게 할 때 유용하다.
    
    ## 환경변수 접근
    
    ```bash
    process.env
    ```
    
    node.js에서는 process.env로 환경변수에 접근한다.
    
    process는 node.js에 기본적으로 내장된 전역 개체로, 별도 import가 필요 없이 어디서든 사용 가능하다.
    
    ![image.png](attachment:1ac2fbe9-5217-4b3d-b492-e490dc0ffb29:image.png)
    
    이렇게 process.env를 출력하면 현재 운영체제 기본 환경변수가 출력된다. 
    
    직접 환경변수를 추가하는 방법은 여러가지가 있는데, cli를 통해 추가할 수도 있다.
    
    ```bash
    key1=value1 # 셸 변수(local variable)
    export key2=value2 # 환경변수 (자식 프로세스에서도 복사되어 사용 가능)
    
    echo $key1
    echo $key2
    ```
    
    단 이 두 방식 모두 현재 실행중인 셸, 터미널이 종료되면 없어지기 때문에,
    
    영구적으로 저장하는 방식은 
    
    - nano ~/.zshrc 에 export key=value 로 저장해두기
    - .env 파일로 관리하기
    
    ## dotenv 라이브러리로 쉽게 관리하기
    
    ```bash
    npm i dotenv
    ```
    
    ```bash
    DB_HOST=localhost
    DB_USER=root
    DB_PASS=1234
    ```
    
    ```bash
    import dotenv from "dotenv";
    
    dotenv.config();
    
    console.log("DB_HOST", process.env.DB_HOST);
    console.log("DB_USER:", process.env.DB_USER);
    console.log("DB_PASS:", process.env.DB_PASS);
    ```
    
- CORS
    
    # CORS란
    
    풀어쓰면 cross-origin resource sharing 교차 출처 리소스 공유 라는 뜻으로,
    
    - 쉬운 설명은 내 웹사이트 브라우저에서 다른 서버의 데이터를 가져다 써도 되는지 확인하는 보안 규칙이다. (헤더 기반 메커니즘)
    - 교차 출처 리소스를 호스팅해주는 서버가 실제로 요청을 허가할 것인지 확인하기 위해 브라우저가 미리 가볍게 보내는 사전 요청(프리플라이트) 메커니즘에 의존한다.
    
    여기서 중요한 개념이 바로 동일 출처 정책(SOP)이다.
    
    - 네이버 백엔드 api는 네이버 브라우저에서만 요청 가능하다.
    - 출처(Origin): 프로토콜 + 도메인 + 포트 가 같아야 동일 출처로 인정된다.
    
    이때 검사를 하는 주체는 웹 브라우저이다. 서버가 응답을 보냈더라도 브라우저가 허가된 사이트인지 확인 후 에러를 띄운다.
    
    만약 다른 출처의 리소스를 불러오려면 그 출처에서 올바른 CORS 헤더를 포함한 응답을 반환해줘야한다.
    
    무엇을 보호하기 위한 장치인가?
    
    - 브라우저 사용자를 잠재적 보안 위협으로부터 보호하기 위한 것이다.
    
    # CORS 동작 과정
    
    ## (1) 요청
    
    웹 클라이언트에서 다른 출처의 리소스를 요청할 때 크로스 오리진 요청 보낸다.
    
    이때 브라우저는 Origin 헤더를 요청에 추가한다.
    
    브라우저가 자동적으로 처리하는 필드로, 임의의 값으로 바꾸는 것 불가능하다.
    
    ```bash
    GET /request
    Host: backend.com
    Origin: https://frontend.com/
    ```
    
    Origin 헤더에는 요청이 이뤄지는 오리진 정보(프로토콜, 도메인, 포트) 정보가 담긴다.
    
    ## (2) Preflight
    
    브라우저는 예비 요청과 본 요청을 나누어 서버로 전송한다.
    
    브라우저가 미리 전송 Preflight 하여 options 메서드를 통해 다른 도메인의 리소스로 http 요청 보내 실제 요청이 전송하기 안전한지 확인한다.
    
    - 서버에 “이 요청 보내도 괜찮을까요?” 하고 물어봄
    - 왜? CORS 정책에 위반하는 것이라면 데이터를 다 보낸 다음에 거절당하는 것은 서버 리소스 낭비이기 때문 → 서버를 보호하기 위해
    
    ### [ 단순 요청의 경우 ]
    
    - GET, HEAD, POST
    - 이때 수동으로 설정할 수 있는 헤더는 아래와 같고
    
    ![image.png](attachment:bc3112ac-4db6-4273-a213-78914b96fa8a:image.png)
    
    Content-type 헤더에 지정된 미디어 타입에 대해 혀용되는 조합은 다음과 같다.
    
    - `application/x-www-form-urlencoded`
    - `multipart/form-data`
    - `text/plain`
    
    ![image.png](attachment:c13753f2-e0a0-4eaf-8d2b-5e805ad71e61:image.png)
    
    만약 Authorization 헤더가 들어있으면 무조건 사전 요청이 발생한다.
    
    예시 (foo.example → bar.other)
    
    브라우저에(foo.example)서의 요청
    
    ```bash
    GET /resources/public-data/ HTTP/1.1
    Host: bar.other
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:71.0) Gecko/20100101 Firefox/71.0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    Accept-Language: en-us,en;q=0.5
    Accept-Encoding: gzip,deflate
    Connection: keep-alive
    **Origin: https://foo.example**
    ```
    
    서버(bar.other)의 응답
    
    ```bash
    HTTP/1.1 200 OK
    Date: Mon, 01 Dec 2008 00:23:53 GMT
    Server: Apache/2
    **Access-Control-Allow-Origin: ***
    Keep-Alive: timeout=2, max=100
    Connection: Keep-Alive
    Transfer-Encoding: chunked
    Content-Type: application/xml
    
    […XML Data…]
    ```
    
    이때 서버에서 Access-Control-Allow-Origin 헤더에 접근 허용할 출처를 적는다. *은 모든 출처를 허용한다는 의미이다.
    
    ### [ 사전 요청(preflighted)이 필요한 경우 ]
    
    - 메서드가 PUT, PATCH, DELETE 등
    - 커스텀 헤더 사용 (예: X-Request-Id, X-Auth-Token)
    - Content-Type: application/json 등 simple 범주 밖
    - Private Network Access 상황(공용 → 사설 네트워크)
    
    실제 요청 보내는 것이 안전한지 판단하기 위해 OPTIONS 메서드 활용해 다른 출처 리소스에 http 요청 미리 보냄
    
    사전 요청시 Access-Control-Request-* 헤더 포함되고
    
    실제 요청 시에는 포함되지 않음
    
    ```tsx
    // client.js
    const fetchPromise = fetch("https://bar.other/doc", {
      method: "POST",
      mode: "cors",
      headers: {
        "Content-Type": "text/xml",
        "X-PINGOTHER": "pingpong",
      },
      body: "<person><name>Arun</name></person>",
    });
    
    fetchPromise.then((response) => {
      console.log(response.status);
    });
    ```
    
    ![image.png](attachment:30d6481b-b5ee-41dd-ac33-3582a289d3ad:image.png)
    
    이때
    
    - credentials 요청이라면 당연히 Allow-Origin에 * 불가
    
    ### Access-Control-Max-Age
    
    cors 예비 요청의 결과를 브라우저가 얼마나 오랫동안 저장(캐싱)할지 설정하는 값
    
    - ex) 같은 요청에 대해서는 preflight 요청을 1시간 동안은 하지 않음
    
    → 이 시간동안 예비 요청 생략하고 바로 본 요청을 보낼 수 있어 네트워크 지연 시간 감소, 서버 부하 감소
    
    ## CORS는 curl이나 postman으로 호출하면 발생하지 않는다.
    
    브라우저에만 적용되는 이유
    
    - 브라우저는 사용자 민감 정보(로그인 세션, 쿠키 등)를 가지고 있기 때문
    
    https://www.devteam.co.kr/blog/development/preflight-%EC%9A%94%EC%B2%AD-%EC%8B%A4%ED%8C%A8-%ED%95%B4%EA%B2%B0-%EB%B0%A9%EB%B2%95-cors-%EC%B5%9C%EC%A0%81%ED%99%94-%EC%8B%A4%EC%A0%84-%EC%82%AC%EB%A1%80
    
    https://developer.mozilla.org/ko/docs/Web/HTTP/Guides/CORS
    
- DB Connection, DB Connection Pool
    
    ## DB 커넥션
    
    애플리케이션 - DB 물리적 연결 통로
    
    - 애플리케이션과 데이터베이스 서버가 통신하도록
    
    db를 연결할 때마다 connection 객체를 새로 만드는 것은 좋지 않음
    
    - 네트워크 비용 - db 연결 설정 → 네트워크 통신, 시간 소요
    
    ## DB 커넥션 풀이란
    
    디비와의 연결을 미리 여러 개 생성해두고 필요할 때마다 재사용하는 기술
    
    - 매번 데이터베이스 연결을 새로 생성하는 것은 자원, 시간 많이 소모
    
    ## 주요 설정
    
    - 최소 연결 수
        - 풀이 관리하는 연결의 최소 개수
        - 서버가 시작될 때 이 수만큼 연결이 미리 생성됨
    - 최대 연결 수
        - 풀이 관리할 수 있는 최대 개수
        - 너무 높게 설정해도 불필요한 자원 소모할 수 있음
    - 연결 대기 시간
        - 모든 커넥션이 사용중일 때 새로운 요청이 커넥션 얻기 위해 기다리는 최대 시간
        - 설정 시간 내 커넥션 확보하지 못하면 예외 발생
    
    ## 사양에 맞는 커넥션 설정하기
    
    AWS RDS mysql max connection 계산식
    
    - 메모리 / 12582880
    - t2.micro 512MB 기준 (512*1024*1024)/12582880 = 40개
    
- 비동기 (async, await)
    
    ## Blocking, Non-Blocking
    
    - 제어권이 누구에게 있는지
    
    ![image.png](attachment:af76c1aa-46d9-4895-b1c3-8ded1050d396:image.png)
    
    ## aync, async
    
    동기와 비동기 차이는 작업 순서를 지키는지 여부이다.
    
    sync
    
    - 코드 한 줄이 끝나야 다음 줄로 넘어간다.
    
    ![image.png](attachment:35ae3c25-2632-4893-919d-37af10161979:image.png)
    
    async
    
    - 요청을 보낸 후 결과 나오지 않아도 다른 일 하러 감
    - 동시에 여러 작업을 처리할 수 있어 효율적인 방식
    
    ![image.png](attachment:545c61aa-936b-4235-be5a-dcd433f5f9f0:image.png)
    
    ## Blocking = sync, non-blocking = async 인가?
    
    함수의 제어권 → block
    
    시간의 개념으로 보면 → sync
    
    ## Block, sync
    
    ![image.png](attachment:99430908-6105-4d20-ac3d-493ee6d7c33b:image.png)
    
    기본적인 프로그래밍 언어 작동 방식
    
    ```tsx
    const fs = require('fs');
    
    console.log("1. 시작");
    const data = fs.readFileSync('test.txt', 'utf8'); // 멈춤
    console.log("2. 내용:", data);
    console.log("3. 끝");
    // 1 - 2 - 3
    ```
    
    ## non-block, sync
    
    ![image.png](attachment:f29483c7-a02b-4103-84d0-492201a4267f:image.png)
    
    언제 끝나는지를 계속 봐야함.
    
    - 게임 로딩 창에서 내 정보도 잠깐잠깐씩 조회할 수 있는 것
    - nodejs  자체에서는 드문 케이스!
    - 운영체제에서 poling 하는 방식 (진행 상황 계속 물어보기)
    
    ```tsx
    // 개념적 예시: 작업이 끝났는지 계속 확인하는 루프
    const fs = require('fs');
    
    console.log("1. 시작");
    // 비동기 함수를 실행했지만, 완료될 때까지 while문으로 계속 감시(Sync적 확인)
    let isDone = false;
    fs.readFile('test.txt', 'utf8', () => { isDone = true; });
    
    while (!isDone) {
        console.log("...아직 안 끝났나요?"); // 논블로킹이라 루프는 돌지만 결과는 동기적으로 기다림
    }
    console.log("2. 완료!");
    
    // 출력 순서: 1 -> ...아직 안 끝났나요? (반복) -> 2
    
    ```
    
    ## block, async
    
    ![image.png](attachment:a42dd0a0-43aa-4116-b2e9-a2d6e58c1e24:image.png)
    
    보통 안티패턴 !!
    
    - 비동기로 청했는데, 정작 메인 스레드에서 무거운 연산 돌려 전체를 막는 경우
    
    ```tsx
    const fs = require('fs');
    
    console.log("1. 시작");
    fs.readFile('test.txt', 'utf8', (err, data) => {
        console.log("3. 비동기 결과 완료"); 
    });
    
    // 엄청난 CPU 연산으로 메인 스레드를 '블로킹' 해버림
    for (let i = 0; i < 10000000000; i++) { } 
    
    console.log("2. 연산 끝");
    
    // 출력 순서: 1 -> (한참 뒤) 2 -> 3
    // 비동기(3)가 준비되어도 연산(2)이 끝날 때까지 출력되지 못함
    ```
    
    ## non-block, async
    
    ![image.png](attachment:2edb575d-2658-4836-a4ac-b913137550ff:image.png)
    
    자바스크립트 작동 방식
    
    - ajax 통신으로 요청 보내놓고 콜백을 통해 불러오는 방식
    
    ```tsx
    const fs = require('fs');
    
    console.log("1. 시작");
    fs.readFile('test.txt', 'utf8', (err, data) => {
        console.log("3. 결과 완료:", data); // 작업 완료 알림(Async)
    });
    console.log("2. 다음 작업 수행 중"); // 제어권을 바로 돌려받음(Non-blocking)
    
    // 출력 순서: 1 -> 2 -> 3 (순서가 뒤바뀜)
    ```
    
    ## await과의 관계?
    
    - async + non-blocking 기반 코드를 sync + blocking 처럼 직관적으로 작성할 수 있게 해주는 문법
    
    await 키워드를 만나면 비동기 작업이 끝날 때까지 해당 async 함수 내부 코드 실행을 일시 중단해 동기적으로 수행하도록.
    
    함수 내부에서는 동기지만 함수 외부(메인 스레드) 차원에서는 논블라킹 상태로 유지되어 다른 요청 처리할 수 있음
    
- try/catch/finally
    
    ## 사용
    
    - try-catch
    - try-finally
    - try-catch-finally
    
    ## 구문
    
    - catch: try 블록에서 예외 발생시 실행될 구문
    - finally: 예외 발생 여부에 관계없이 항상 실행되는 것
    
    ## 이건 어떻게 될까?
    
    ```tsx
    function doIt() {
      try {
        return 1;
      } finally {
        return 2;
      }
    }
    ```
    
    - 실제로는 finally에 리턴을 쓰는 것은 지양
    - 오직 작업 정리를 위한 코드에만 사용하기
    
    ## 무조건적 catch
    
    ```tsx
    try {
      throw "myException"; // generates an exception
    } catch (e) {
      // statements to handle any exceptions
      logMyErrors(e); // pass exception object to error handler
    }
    ```
    
    ## 조건적 catch
    
    ```tsx
    try {
      myroutine(); // may throw three types of exceptions
    } catch (e) {
      if (e instanceof TypeError) {
        // statements to handle TypeError exceptions
      } else if (e instanceof RangeError) {
        // statements to handle RangeError exceptions
      } else if (e instanceof EvalError) {
        // statements to handle EvalError exceptions
      } else {
        // statements to handle any unspecified exceptions
        logMyErrors(e); // pass exception object to error handler
      }
    }
    ```
    
    ## 중첩 try 블록
    
    ```tsx
    try {
      try {
        throw new Error("oops");
      } finally {
        console.log("finally");
      }
    } catch (ex) {
      console.error("outer", ex.message);
    }
    
    // Logs:
    // "finally"
    // "outer" "oops"
    ```
    
    ```tsx
    try {
      try {
        throw new Error("oops");
      } catch (ex) {
        console.error("inner", ex.message);
      } finally {
        console.log("finally");
      }
    } catch (ex) {
      console.error("outer", ex.message);
    }
    ```
    
    - 답
        
        ”inner" "oops"
        "finally"
        
        이미 안쪽 catch가 에러를 받아 처리함
        따라서 안쪽 에러가 밖으로 전파되지 않음
        
    
- Interface(인터페이스)
    
    ## 인터페이스
    
    node.js 프로젝트에서 타입스크립트 사용할 때 
    
    객체 구조 정의할 때 사용하는 문법
    
    - 객체가 어떤 속성, 메서드를 가져야 하는지 정의하는 설계도
    - ts 문법이기에 컴파일될 때 js로 컴파일되지 않음
    
    ```tsx
    // 인터페이스명은 대문자로 짓는다
    interface Human {
      name: string; // name 키는 문자열 타입
      age: number; // age 키는 넘버 타입
      boo(): void; // boo 함수는 void 타입
    }
    
    // 인터페이스 자체를 타입으로 줘서 객체 생성
    const person: Human = {
      name: "da",
      age: 5,
      boo: () => console.log("this is boo"),
    };
    
    // 매개변수에서 인터페이스를 타입으로 받는다.
    function booboo(a: Human): void {
      console.log(`${a.name} is ${a.age} years old`);
    };
    
    booboo(person); // da is 5 years old
    person.boo(); // this is boo
    ```
    
    ## 인터페이스 확장
    
    ```tsx
    interface Person {
       name: string;
    }
    
    interface Developer extends Person {
       skill: string;
    }
    
    let fe: Developer = { name: 'josh', skill: 'TypeScript' };
    ```
    
    클래스와 달리 여러개를 extends 가능하다.
    
    ```tsx
    interface Person {
       name: string;
       age: number;
    }
    
    interface Programmer {
       favoriteProgrammingLanguage: string;
    }
    
    interface Korean extends Person, Programmer { // 두개의 인터페이스를 받아 확장
       isLiveInSeoul: boolean;
    }
    
    const person: Korean = {
       name: '홍길동',
       age: 33,
       favoriteProgrammingLanguage: 'kor',
       isLiveInSeoul: true,
    };
    ```
    
    ## 클래스로 인터페이스 구현
    
    ```tsx
    // 1. 인터페이스 정의 (계약)
    interface Logger {
      log(message: string): void; // 함수 시그니처
      error(message: string): void;
    }
    
    // 2. 클래스에서 인터페이스 구현 (계약 이행)
    class ConsoleLogger implements Logger {
      log(message: string): void {
        console.log(`[INFO]: ${message}`);
      }
      
      error(message: string): void {
        console.error(`[ERROR]: ${message}`);
      }
    }
    ```
    
- Type Assertion(as 키워드)
    
    ## as 키워드
    
    - 타입스크립트에만 있음!
    - 변수나 오브젝트 타입 지정해줄 때 사용
    - 다만, 타입에 확신이 있을 때 사용하자!
    
    ```tsx
    const num = 10;
    const value = num as number;
    ```
    
    ## 고려할 것
    
    - type assertion을 사용하면 타입 유형 검사를 우회 → 잘못된 타입으로 단언되면 런타임 오류 발생 가능
    - 타입을 변환시켜주는게 아니라 단순히 타입스크립트에서 컴파일 오류를 해제시키는 기능으로 수행하기 때문
    - 웬만하면 지양하기