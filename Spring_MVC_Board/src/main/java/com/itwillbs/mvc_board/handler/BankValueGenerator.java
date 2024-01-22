package com.itwillbs.mvc_board.handler;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Component;

//핀테크 요청 작업에 사용할 다양한 값을 생성하는 클래스
//=> 스프링 빈으로 관리하기 위해 @Component 어노테이션 적용
@Component
public class BankValueGenerator {
	// 거래고유번호 자동 생성할 getBankTranId() 메서드 정의
	// => 파라미터 : 없음   리턴타입 : String
	// => 생성 규칙(3.11. 거래고유번호(참가기관) 생성 안내)
	//    이용기관코드(10자리) + 생성주체기본코드("U") + 이용기관 부여번호(9자리)
	//    ex) F123456789U4BC34239Z
	//    (이 때, 이용기관코드는 금융결제원 API 사이트에서 조회 가능)
	public String getBankTranId() {
		String bank_tran_id = "";
		
		// 만약, 이용기관 부여번호(9자리)가 정수형 난수로만 구성될 경우
		// => java.security.SecureRandom 클래스 활용 가능(java.util.Random 클래스 사용 X)
//		SecureRandom sr = new SecureRandom();
//		int rNum = sr.nextInt(1000000000); // 0 ~ 999999999 사이의 난수 발생 시켜야하므로 총 10자리 들어가야함
//		System.out.println(rNum);
		// 단, 9자리보다 작은 정수(또는 실수)형 난수는 앞자리에 0이 올 경우 표현되지 않으므로
		// 9자리 난수 문자열로 활용이 불가능할 수 있다!
		// 따라서, 문자열 포맷 처리 작업을 통해 9자리 미만일 경우 앞에 0 추가하는 작업 필요
		// => 추출된 난수를 String 클래스의 format() 메서드를 통해 9자리 문자열 형식으로 변환하되
		//    부족한 자릿수(앞자리)는 0으로 채우기
//		bank_tran_id = String.format("%d", rNum); // 정수 1개를 rNum 값을 활용하여 문자열로 변환
//		bank_tran_id = String.format("%09d", rNum); // 9자리 정수 중 빈 자리는 0으로 채움
		// ======================================================================================
		// GenerateRandomCode - getRandomCode() 메서드 재사용 => 파라미터로 난수 길이 전달
		// => 리턴받은 알파벳숫자 난수를 모두 대문자로 변환 시 toUpperCase() 메서드 활용
//		bank_tran_id = GenerateRandomCode.getRandomCode(9).toUpperCase();
		bank_tran_id = "M202113854" + "U" + GenerateRandomCode.getRandomCode(9).toUpperCase();
		
		return bank_tran_id;
	}

	// 작업 요청일시(거래시간 등) 자동 생성할 getTranDTime() 메서드 정의
	// => 파라미터 : 없음   리턴타입 : String
	// => 현재 시스템의 날짜 및 시각을 기준으로 14자리 문자열 생성(yyyyMMddHHmmss 형식 활용)
	// => java.time.LocalDateTime 클래스와 java.time.DateTimeFormatter 활용
	public String getTranDTime() {
		// 현재 시스템의 날짜 및 시각 정보 가져오기
		LocalDateTime localDateTime = LocalDateTime.now();
		
		// DateTimeFormatter 클래스의 ofPattern() 메서드 활용하여 표시할 날짜 포맷 지정
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		
		// LocalDateTime 객체에 포맷을 적용하여 문자열로 리턴되는 날짜 및 시각 정보 리턴
		return localDateTime.format(dateTimeFormatter);
	}
}














