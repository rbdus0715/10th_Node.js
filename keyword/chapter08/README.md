- Swagger& OpenAPI
    
    # open api
    
    restful api 설계와 구조를 기술하는 표준 규격
    
    - json, yaml 형식의 파일
    - api 경로, 파라미터, 응답 데이터 규격을 정의함
    
    # swagger
    
    openapi 표준 구현을 지원하는 오픈소스 소프트웨어 도구
    
    - 정의된 문서 시각화, 웹에서 직접 테스트할 수 있음
    
    ### 스웨거 기능
    
    - swagger-editor
        - yaml, json 형식 사용해서 브라우저에서 직접 디자인하고 편집하는 코드 편집기(swagger-ui 내장)
    - swagger-codegen
        - 작성된 api 명세서 기반으로 소스 코드를 자동으로 생성하는 툴
    - swagger-ui → 시각화
        - api 명세서를 사람이 읽기 쉬운 웹 페이지로 시각화해주는 도구
    - swagger-inspector
        
        ![image.png](attachment:228e8387-b8a2-44e0-b0fb-d02b2b670b62:image.png)
        
        - postman 처럼 직접 테스트, 유효성 검증하는 클라우드기반 툴
    - swagger-hub
        - 통합 플랫폼(앞선 도구들 모두 통합 관리 가능)
    
- TSOA(TypeScript-first OpenAPI) (핵심적인 부분이라 한번 더 넣었어요!)
    
    ### TSOA
    
    typescript 환경에서 데코레이터 기반으로 swagger 문서 및 라우팅 코드를 자동으로 생성해주는 프레임워크
    
    - @Route, @Get, @Post 데코레이터 기반으로 OpenAPI 스펙 자동 생성
    - @Route(), @Get() 을 참고해서 자동으로 라우팅 코드 작성해줌
    - 유효성 검사 기능
    
    유효성 검사 기능은 JSDoc 주석 형식을 통해 지정
    
    → Swagger/OpenAPI 문서화 + 실제 런타입 데이터 검증까지 자동으로 수행해줌
    
    ```tsx
    interface ProductDto {
      /**
       * 상품명은 최소 3글자, 최대 20글자여야 합니다.
       * @minLength 3
       * @maxLength 20
       */
      name: string;
    
      /**
       * 가격은 최소 100원 이상, 1,000,000원 이하여야 합니다.
       * @minimum 100
       * @maximum 1000000
       */
      price: number;
    
      /**
       * 정수만 허용합니다. (소수점 탈락)
       * @isInt
       */
      quantity: number;
    
      /**
       * 정규표현식(Regex) 검사 - 소문자 알파벳과 숫자 조합만 허용
       * @pattern ^[a-z0-9]+$
       */
      code: string;
    }
    
    ```
    
- Type-Driven-Documentation ? development ?
    
    # 타입 주도 개발
    
    타입을 가장 먼저 정의하고, 이 타입을 가이드라인으로 삼아 코드를 올바르게 완성해나가는 개발 방법론
    
    - 일반적인 개발: 주문 처리 함수 → 로직 먼저 작성 → 인자, 반환값에 타입을 맞춤 → 실행 → 예상치 못한 런타임 오류
    - 타입주도 개발:
        - 결제 전, 결제 완료 상태 등을 표현하는 타입 명확히 정의
        - 입력 타입, 출력 타입만 지정한 껍데기 함수 만들기
        - 컴파일러 가이드 받으면서 내부 로직 완성하기
    
    ### Zod 라이브러리 활용
    
    ex) 올바른 이메일 주소 받기
    
    ```tsx
    function(email: string) {
    	if email.contains("@") // 함수 여기저기에서 검증해야한다.
    }
    ```
    
    타입주도 방식으로 수정
    
    → 단순 문자열이 아닌 EmailAddress라는 새로운 타입을 정의하고 이 타입은 오직 골뱅이가 포함된 올바른 문자열로만 생성될 수 있도록 제약 걸기
    
    ```tsx
    import { z } from 'zod';
    
    // 이메일 전용 타입 선언
    export const EmailSchema = z.string().email("올바른 이메일 형식이 아닙니다.");
    export type EmailAddress = z.infer<typeof EmailSchema>;
    
    export const RegisterUserSchema = z.object({
      email: EmailSchema,
      password: z.string().min(8, "비밀번호는 최소 8자리 이상이어야 합니다."),
      age: z.number().min(19, "성인만 가입할 수 있습니다.")
    });
    export type RegisterUserDTO = z.infer<typeof RegisterUserSchema>;
    
    ```
    
    그리고 요청을 검증하는 미들웨어를 구축한다.
    
    ```tsx
    import { Request, Response, NextFunction } from 'express';
    import { AnyZodObject, ZodError } from 'zod';
    
    export const validateRequest = (schema: AnyZodObject) => {
      return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
        try {
          req.body = await schema.parseAsync(req.body);
          next();
        } catch (error) {
          if (error instanceof ZodError) {
            res.status(400).json({ success: false, errors: error.errors });
            return;
          }
          next(error);
        }
      };
    };
    
    ```
    
    이렇게 만든 미들웨어를 라우터 서비스에 추가한다.
    
    ```tsx
    import { Router, Request, Response } from 'express';
    import { RegisterUserSchema, RegisterUserDTO } from './schemas';
    import { validateRequest } from './middleware';
    
    const router = Router();
    
    // service
    async function registerUserService(userData: RegisterUserDTO) {
      return { id: "user_123", email: userData.email };
    }
    
    router.post(
      '/register', 
      validateRequest(RegisterUserSchema), // 타입 확인
      async (req: Request, res: Response) => {
    	  // 무조건 RegisterUserDTO임을 확신 가능 (as)
        const validatedData = req.body as RegisterUserDTO; 
        const newUser = await registerUserService(validatedData);
        res.status(201).json(newUser);
      }
    );
    
    export default router;
    ```