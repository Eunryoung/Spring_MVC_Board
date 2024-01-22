package com.itwillbs.mvc_board.handler;

import java.net.URI;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.itwillbs.mvc_board.controller.FintechController;
import com.itwillbs.mvc_board.vo.ResponseTokenVO;
import com.itwillbs.mvc_board.vo.ResponseUserInfoVO;

@Component
public class BankApiClient {
	
	@Autowired
	private BankValueGenerator bankValueGenerator;
	
	private static final Logger logger = LoggerFactory.getLogger(BankApiClient.class);

	
	
	// 2.1.2. 토큰발급 API - 사용자 토큰 발급 API 요청
	// https://testapi.openbanking.or.kr/oauth/2.0/token 로 실제 요청을 발생 시킬 것(POST)
	public ResponseTokenVO requestAccessToken(Map<String, String> authResponse) {
		// 금융결제원 오픈API 요청 작업 처리
		// POST 방식 요청을 수행하기 위해 URL 정보 생성
		URI uri = UriComponentsBuilder
				.fromUriString("https://testapi.openbanking.or.kr/oauth/2.0/token") // 기본 주소
				.encode()
				.build() // 여기까지 작업으로 UriComponents 객체 생성
				.toUri(); // 이 주소를 가지고 uri 객체를 만들어줌
				// => 어떤 메서드의 리턴타입이 자기자신의 타입일 때 메서드 복수개 연결해 객체 만들어 나가는 과정(Builder Pattern)
		
		// POST 방식 요청의 경우 파라미터(데이터)를 URL 에 결합하지 않고
		// 별도로 body 에 포함시켜 전달해야한다.
		// 따라서, 해당 파라미터 데이터를 별도의 객체로 생성 필요
		// 요청에 필요한 파라미터를 LinkedMultiValueMap 객체 활용하여 설정(별도의 클래스를 만들지않는 방법)
		LinkedMultiValueMap<String, String> parameters = new LinkedMultiValueMap<String, String>();
		// LinkedMultiValueMap 객체의 add() 메서드를 호출하여 파라미터 전달(키, 값 형식으로 설정)
		parameters.add("code", authResponse.get("code")); // 인증코드(인증코드 요청을 통해 응답받은 데이터)
		parameters.add("client_id", "4066d795-aa6e-4720-9383-931d1f60d1a9");
		parameters.add("client_secret", "36b4a668-94ba-426d-a291-771405e498e4"); // 강사님 기본정보.txt 파일에 있는 값 가져다쓰기(마이페이지)
		parameters.add("redirect_uri", "http://localhost:8081/mvc_board/callback");
		parameters.add("grant_type", "authorization_code"); //  고정값: authorization_code
		
		// HttpEntity 객체를 활용하여 요청에 사용될 파라미터를 관리하는 객체를 요청 형식에 맞게 변환
		// => 헤더 정보와 바디 정보를 함께 관리해 주는 객체
		// => 제네릭타입은 파라미터를 관리하는 객체 타입으로 지정하고
		//    생성자 파라미터로 파라미터 관리 객체 전달
		// => 바디 정보만 설정하고 헤더 정보는 기본 헤더 사용하므로 헤더 생략 
		HttpEntity<LinkedMultiValueMap<String, String>> httpEntity =
				new HttpEntity<LinkedMultiValueMap<String,String>>(parameters);
		
		
		// REST API 요청을 위해 RestTemplate 객체 활용해 요청 수행
		// 1) RestTemplate 객체 생성
		RestTemplate restTemplate = new RestTemplate();
		// 2) RestTemplate 객체의 exchange() 메서드 호출하여 POST 방식 요청 수행 가능
		//    파라미터 : 요청 URL 을 관리하는 URI 객체, 요청 메서드(HttpMethod.XXX)
		//               요청 정보를 관리하는 HttpEntity 객체
		//               => 요청정보에는 헤더, 바디가 있지만 현재 실습에서는 지금 헤더 정보를 세팅할 일이 없음
		//               요청에 대한 응답 전달 시 JSON 타입의 응답 데이터를 자동으로 파싱할 클래스
		//    => 이 메서드 호출 시점에 실제 HTTP 요청 발생함
		//    리턴타입 : 응답 정보를 관리할 ResponseEntity<T> 타입이며, 
		//               이 때 제네릭타입은 XXX.class 로 지정한 클래스 타입 지정
		//               => .class 붙여야 이 클래스 타입으로 관리됨
		//               (주의! JSON 타입 응답 데이터 자동 파싱을 위해 Gson, Jackson 등 라이브러리 필요)
		//               (자동 파싱 불가능할 경우 org.springframework.web.client.UnknownContentTypeException: Could not extract response: no suitable HttpMessageConverter found for response type [class com.itwillbs.mvc_board.vo.ResponseTokenVO] and content type [application/json;charset=UTF-8] 예외 발생)
		ResponseEntity<ResponseTokenVO> responseEntity 
				= restTemplate.exchange(uri, HttpMethod.POST, httpEntity, ResponseTokenVO.class); 
		// => 만약, 헤더 정보 또는 파라미터 등의 커스터마이징 불필요할 경우
		//    exchange() 메서드 대신 postForEntity() 메서드 사용
		//    (GET 방식도 마찬가지이나 그냥 exchange()로 통일하는 경우가 많음)
		
		// 응답 정보 확인(ResponseEntity 객체 메서드 활용)
		logger.info("응답 코드 : " + responseEntity.getStatusCode()); // 응답 코드 : 200 OK
		logger.info("응답 헤더 : " + responseEntity.getHeaders());
		// => 응답 헤더 : [transfer-encoding:"chunked", Pragma:"no-cache", Cache-Control:"no-store", X-Content-Type-Options:"nosniff", X-XSS-Protection:"1; mode=block", X-Frame-Options:"DENY", Content-Type:"application/json;charset=UTF-8", Date:"Mon, 22 Jan 2024 01:49:42 GMT"]
		logger.info("응답 본문 : " + responseEntity.getBody());
		// 응답 본문 : ResponseTokenVO(access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIxMTAxMDQzMzQyIiwic2NvcGUiOlsiaW5xdWlyeSIsImxvZ2luIiwidHJhbnNmZXIiXSwiaXNzIjoiaHR0cHM6Ly93d3cub3BlbmJhbmtpbmcub3Iua3IiLCJleHAiOjE3MTM2NjUwNjYsImp0aSI6ImFmNzY4MTljLTVlMGMtNGUzOS1iNzU4LTI4ZWE5M2Q4ZjczOCJ9.fBIypVszAW91bL4wZi8JkT-XRiSYJcPXsHzlKog1vog, token_type=Bearer, expires_in=7775999, refresh_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIxMTAxMDQzMzQyIiwic2NvcGUiOlsiaW5xdWlyeSIsImxvZ2luIiwidHJhbnNmZXIiXSwiaXNzIjoiaHR0cHM6Ly93d3cub3BlbmJhbmtpbmcub3Iua3IiLCJleHAiOjE3MTQ1MjkwNjYsImp0aSI6ImI4NDU4N2I0LTk5NzMtNDM5My05NzllLTlhNTBhZjJmMzI3YiJ9.ykJM44sATrA-i2SNhdKWywksWpinpbrvPsxkMoK9VsE, scope=inquiry login transfer, user_seq_no=1101043342)

		// ResponseEntity 객체의 getBody() 메서드를 호출하여 요청에 대한 응답 결과 리턴
		// => 리턴타입 : ResponseEntity 객체가 관리하는 제네릭타입(ResponseTokenVO)
		return responseEntity.getBody();
		
	}

	// 2.2. 사용자/서비스 관리 - 2.2.1. 사용자정보조회 API 요청(GET)
	// https://testapi.openbanking.or.kr/v2.0/user/me
//	public ResponseUserInfoVO requestUserInfo(Map<String, String> map) { // 리턴타입 VO 사용 시
	public Map<String, Object> requestUserInfo(Map<String, String> map) { // 리턴타입 Map 사용 시
//		logger.info("requestUserInfo() - 파라미터 : " + map);
		
		// GET 방식 요청에 대한 헤더 정보(엑세스토큰)와 파라미터 설정
		// 1. 사용자 정보 조회 시 엑세스 토큰 값을 헤더에 담아 전송하므로
		//    org.springframework.http.HttpHeaders 객체 생성 후 
		//    add() 메서드를 통해 헤더에 정보 추가
		HttpHeaders headers = new HttpHeaders();
		// 헤더명 : "Authorization", 헤더값 : "Bearer" 문자열 뒤에 엑세스토큰 결합(공백으로 구분)
		headers.add("Authorization", "Bearer " + map.get("access_token"));
		
		// 2. 헤더 정보를 갖는 HttpEntity 객체 생성(제네릭타입은 String 지정)
		//    => 파라미터 : 헤더 정보가 저장되어 있는 HttpHeaders 객체
		//    => GET 방식 요청에서는 파라미터만 존재할 경우 body 생략이 가능함
		//       (GET 방식이라 바디 필요없어서 헤더만 세팅함(위와 반대))
		HttpEntity<String> httpEntity = new HttpEntity<String>(headers);
		
		// 3. 요청에 필요한 URI 정보 생성
		//    => GET 방식 요청에 사용할 파라미터는 UriComponentsBuilder 의 queryParam() 메서드 활용
		URI uri = UriComponentsBuilder
				.fromUriString("https://testapi.openbanking.or.kr/v2.0/user/me")
				.queryParam("user_seq_no", map.get("user_seq_no")) // 파라미터(사용자번호)
				.encode() // 파라미터에 대한 인코딩 처리
				.build() // UriComponents 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 4. RestTemplate 객체 생성
		RestTemplate restTemplate = new RestTemplate();
		
		// 5. RestTemplate 객체의 exchange() 메서드 호출하여 HTTP 요청 수행(GET 방식)
		// => 파라미터 : URI 객체, 요청방식, HttpEntity 객체, 응답데이터 관리 클래스(ResponseUserInfoVO)
		// => 리턴타입 : ResponseEntity<ResponseUserInfoVO>
//		ResponseEntity<ResponseUserInfoVO> responseEntity
//			= restTemplate.exchange(uri, HttpMethod.GET, httpEntity, ResponseUserInfoVO.class);
		// => 만약, 헤더 정보 또는 파라미터 등의 커스터마이징 불필요할 경우
		//    exchange() 메서드 대신 getForEntity() 메서드 사용
		//    (post 방식도 마찬가지이나 그냥 exchange()로 통일하는 경우가 많음)
		
		
		// 만약, 응답데이터를 Map 타입으로 처리할 경우
		// => 응답 처리 클래스 타입을 ParameterizedTypeReference 클래스 익명 객체 생성 형태로
		//    제네릭타입을 <Map<String, Object> 타입으로 지정
		ResponseEntity<Map<String, Object>> responseEntity
				= restTemplate.exchange(uri, HttpMethod.GET, httpEntity, new ParameterizedTypeReference<Map<String, Object>>(){});
		
		// ResponseEntity 객체의 getBody() 메서드 호출하여 응답 데이터 리턴
		return responseEntity.getBody();
		
	}

	// 2.3.1. 잔액조회 API 요청(GET)
	// https://testapi.openbanking.or.kr/v2.0/account/balance/fin_num
	public Map<String, Object> requestAccountDetail(Map<String, String> map) {
		// 파라미터로 사용할 난수 생성하여 리턴받기
		String bank_tran_id = bankValueGenerator.getBankTranId();
		logger.info(">>>>>>>>>>>>>>> 은행거래고유번호(bank_tran_id) : " + bank_tran_id);
		
		String tran_dtime = bankValueGenerator.getTranDTime();
		logger.info(">>>>>>>>>>>>>>> 요청일시(tran_dtime) : " + tran_dtime);
		
		
		// GET 방식 요청에 대한 헤더 정보(엑세스토큰)와 파라미터 설정
		// 1. 사용자 정보 조회 시 엑세스 토큰 값을 헤더에 담아 전송하므로
		//    org.springframework.http.HttpHeaders 객체 생성 후 
		//    add() 메서드를 통해 헤더에 정보 추가
		HttpHeaders headers = new HttpHeaders();
		// 헤더명 : "Authorization", 헤더값 : "Bearer" 문자열 뒤에 엑세스토큰 결합(공백으로 구분)
		headers.add("Authorization", "Bearer " + map.get("access_token"));
		
		// 2. 헤더 정보를 갖는 HttpEntity 객체 생성(제네릭타입은 String 지정)
		//    => 파라미터 : 헤더 정보가 저장되어 있는 HttpHeaders 객체
		//    => GET 방식 요청에서는 파라미터만 존재할 경우 body 생략이 가능함
		HttpEntity<String> httpEntity = new HttpEntity<String>(headers);
		
		// 3. 요청에 필요한 URI 정보 생성
		//    => GET 방식 요청에 사용할 파라미터는 UriComponentsBuilder 의 queryParam() 메서드 활용
		URI uri = UriComponentsBuilder
					.fromUriString("https://testapi.openbanking.or.kr/v2.0/account/balance/fin_num")
					.queryParam("bank_tran_id", bank_tran_id) // 거래고유번호(참가기관)
					.queryParam("fintech_use_num", map.get("fintech_use_num")) // 핀테크이용번호
					.queryParam("tran_dtime", tran_dtime) // 요청일시
					.encode() // 파라미터에 대한 인코딩 처리
					.build() // UriComponents 객체 생성
					.toUri(); // URI 타입 객체로 변환
		
		// 4. RestTemplate 객체 생성
		RestTemplate restTemplate = new RestTemplate();
		
		// 5. RestTemplate 객체의 exchange() 메서드 호출하여 HTTP 요청 수행(GET 방식)
		// => 파라미터 : URI 객체, 요청방식, HttpEntity 객체, 응답데이터 관리 클래스
		// => 리턴타입 : ResponseEntity<Map<String, Object>
		ResponseEntity<Map<String, Object>> responseEntity
				= restTemplate.exchange(uri, HttpMethod.GET, httpEntity, new ParameterizedTypeReference<Map<String, Object>>() {});
					
		// ResponseEntity 객체의 getBody() 메서드 호출하여 응답 데이터 리턴
		return responseEntity.getBody();
	}
	
}


