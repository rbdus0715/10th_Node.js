- OAuth 2.0
    
    ![image.png](attachment:9f466b67-3d39-4a31-8047-efb9a93cb3a0:image.png)
    
    문제점: 보안
    
    OAuth
    
    - 구글에 인가되기 위해 원래 인증이 필요하다.
    - 인증은 유저가 수행, 권한은 서비스가 받는 것
    - Oauth는 인가를 위해 탄생한 기술이다.
    
    # Oauth flow
    
    - 유저 - Resource Owner : 인증 수행 주체
    - 서비스 - Client Third-party Application : 권한을 위임받는 주체
    - 구글
        - Authorization Code : 인증 검증하고 권한 부여하는 주체
        - Resource Server : 인가를 수행하고 리소스 제공하는 주체
    
    먼저 OAuth 세팅하자.
    
    ![image.png](attachment:f81513ca-71c1-4d71-a1dc-8a3606eafbd7:image.png)
    
    ![image.png](attachment:9f763c32-b526-4ce3-b769-ded27b935172:image.png)
    
    흐름은 어떻게 되나
    
    ![image.png](attachment:d1eb72ec-1b97-449a-8fbb-5e4323fd1e84:image.png)
    
    ![image.png](attachment:27f53221-9ff2-497f-a470-0365b31f9456:image.png)
    
    - response_type은 Authorization 코드
    - client_id: 서비스 식별자
    - redirect_uri: 권한을 반환받는 엔드포인트(내 서버)
    - scope: 허용한 권한들
    
    ![image.png](attachment:37a62722-dfaf-422f-8a88-354d2c045f23:image.png)
    
    추가적인 권한을 입력받을 수도 있다.
    
    ![image.png](attachment:b50fc43a-3309-44e6-98e4-5609394b1d6f:image.png)
    
    클라이언트는 로그인 페이지 URL만 제공해주고 인증과정은 다 구글이 해준다.
    
    인증이 완료되면 구글에서는 Authorzation code 반환해준다.
    
    ![image.png](attachment:ea07be8c-34f9-4ce4-b001-6431c3bfa4ee:image.png)
    
    내 서버에서는 다시 Authorization code를 사용해서 또 AccessToken 발급한다.
    
    - 이때 grant_type은 OAuth 2.0 핵심 동작 방식 중 어떤 시나리오를 사용할 것인지를 인증 서버에 알려주는 파라미터
    
    ![image.png](attachment:45f91328-2a30-405e-9240-23518b1a502f:image.png)
    
    - 여기서는 무조건 https를 사용하기를 권장하고있다.
    
    인가 과정
    
    ![image.png](attachment:0109106b-d3a2-4f60-821f-27ac75bff8ff:image.png)
    
    소셜 로그인 구현하기 위해서는 인증 서버에게 accessToken을 요청하면서 유저 프로필 정보도 요청하면 된다.
    
    # Open ID Connect
    
    - OAuth2.0의 경우 로그인 인증 후 AccessToken 출입증을 받는다. 이 출입증은 문을 열수만 있고, 유저가 누구인지 써있지 않다.
        - 유저 정보를 알기 위해 내 정보 보기 API 1번은 호출해야한다.
    - OIDC같은 경우 로그인 인증 성공하면 출입증과 ID Token을 동시해 준다. 이 토큰을 열어보면 유저 고유 id, 이메일, 이름 들어있음
        - 추가 API 호출 없이 바로 로그인 완료
    
    ```cpp
    export const googleStrategy = new GoogleStrategy(
      {
        clientID: process.env.PASSPORT_GOOGLE_CLIENT_ID!,
        clientSecret: process.env.PASSPORT_GOOGLE_CLIENT_SECRET!,
        callbackURL: '/oauth2/callback/google',
        scope: ['email', 'profile'],
      },
      async (_accessToken, _refreshToken, profile, cb) => {
        try {
          const user = await googleVerify(profile);
          const tokens: AuthTokens = {
            accessToken: generateAccessToken(user),
            refreshToken: generateRefreshToken(user),
          };
          return cb(null, tokens);
        } catch (err) {
          return cb(err as Error);
        }
      },
    );
    ```
    
    - 위 코드는 OAuth로 OICD 방식을 흉내낸 것이다.
    - ccess token으로 userInfo 엔드포인트를 호출해서 프로필을 받아 그걸로 로그인 처리하는 방식
- JWT
    
    ### JWT: json web token
    
    json 객체로 두 개체 간 정보를 안전하고 간결하게 전송하는 토큰
    
    - **Header (헤더)**
        - 토큰의 타입(JWT)과 서명에 사용된 암호화 알고리즘(HS256, RS256)을 명시
    - **Payload**
        - 토큰에 담을 실제 정보
        - 여기에 포함되는 정보 단위를 클레임(Claim)이라고 부르며, 사용자의 ID나 토큰 만료 시간 등을 포함
    - **Signature (서명)**
        - 헤더와 페이로드의 인코딩 값과 서버가 가진 비밀 키(Secret Key)를 합쳐서 헤더에 지정된 알고리즘으로 생성한 값
        - 이 서명을 통해 토큰이 도중에 위조되거나 변조되지 않았음을 증명
    
- Bearer Token
    
    이 토큰을 갖고 있는(Bear) 사람을 인증된 사용자로 인정하겠다는 규칙을 가진 토큰 인증 방식
    
    장점
    
    - stateless
    - 웹 브라우저 뿐만 아니라 모바일 앱, iot 기기 등 http 통신할 수 있는 모든 환경에서 헤더에 문자열 한 줄만 추가하면 되어 연동 매우 쉬움
    
    단점
    
    - 보안 위험
    
    해결책
    
    - https 필수 적용: 네트워크 중간에 패킷을 가로채지 못하도록 무조건 데이터를 암호화하는 https(ssl/tls) 강제
    - 짧은 유효기간: 토큰 탈취당하더라도 피해 최소화하기 위해 실제 api를 호출할 때 쓰는 Acceesstoken은 짧게.