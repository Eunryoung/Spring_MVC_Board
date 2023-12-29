package com.itwillbs.mvc_board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.mvc_board.handler.GenerateRandomCode;
import com.itwillbs.mvc_board.handler.SendMailClient;
import com.itwillbs.mvc_board.vo.MemberVO;

@Service
public class SendMailService {
	@Autowired
	private SendMailClient mailClient;
	
	// 인증 메일 발송 요청을 위한 sendAuthMail() 메서드
	public String sendAuthMail(MemberVO member) {
		// 인증 메일에 포함시켜 전달할 난수 생성
		String auth_code = GenerateRandomCode.getRandomCode(50);
		System.out.println("생성된 난수 : " + auth_code);
		
		// --------------------------------------------------------------------
		// 인증 메일에 포함할 제목과 본문 생성
		String subject = "[아이티윌] 가입 인증 메일입니다.";
//		String content = "인증코드 : " + auth_code; // 코드만 보내는 형식
		
		// 이메일 본문에 인증에 사용될 주소 및 각종 정보를 포함하는 하이퍼링크 표시할 경우
		// => URL 파라미터로 아이디와 인증코드 전달
		String content = "<a href='http://localhost:8081/mvc_board/MemberEmailAuth?id=" + member.getId() + "&auth_code=" + auth_code + "'>" 
							+ "이메일 인증을 수행하려면 이 링크를 클릭해 주세요!</a>";
		// ----------------------------------------------------
		// SendMailClient - sendMail() 메서드 호출하여 메일 발송 요청
		// => 파라미터 : 이메일, 제목, 본문
		// => 단, 메일 발송과 인증 코드 등록 작업을 별도로 동작시키기 위해
		//    메일 발송 메서드 호출 기능을 자바의 쓰레드(Thread)를 활용하여 호출
		// => 메일 발송이 완료되지 않더라도 생성된 인증코드를 리턴할 수 있게 됨
//		mailClient.sendMail(member.getEmail(), subject, content); // null 인지 아닌지도 판별해야함!!
		// => 익명 객체를 활용하여 1회용 쓰레드 생성
		//    new Thread(new Runnable() { public void run() { 멀티쓰레드코드... }}).start();
		//    사용자가 기다리지않게 혹은 기다리면서 다른 작업을 할 수 있도록 스레드 생성
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				mailClient.sendMail(member.getEmail(), subject, content); 
				// => 원래는 익명 객체 안의 변수가 final이어야 한다 
				//    but 자바 1.8 버전 이후로는 익명 객체안의 변수가 final이 아니어도 알아서 컴파일해줌
			}
		}).start();
		
		// 발송된 인증코드 리턴
		return auth_code;
	}

}
