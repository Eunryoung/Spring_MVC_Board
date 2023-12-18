package com.itwillbs.mvc_board.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/*
[ spring_mvc_board5.member 테이블 정의 ]
----------------------------------------
번호(idx) - 정수, PK, 자동증가(AUTO_INCREMENT)
이름(name) - 문자(10자), NN
아이디(id) - 문자(16자), UN, NN
패스워드(passwd) - 문자(100자), NN => 패스워드 암호화 기능 추가를 위해 길이 100자로 늘림
주민번호(jumin) - 문자(14자), UN, NN
우편번호(post_code) - 문자(10자), NN
기본주소(address1) - 문자(100자), NN
상세주소(address2) - 문자(100자), NN
이메일(email) - 문자(50자), UN, NN
직업(job) - 문자(10자), NN
성별(gender) - 문자(1자), NN
취미(hobby) - 문자(50자), NN
가입동기(motivation) - 문자(500자), NN
가입일(reg_date) - 날짜(DATETIME), NN
회원상태(member_status) - 정수, NN(1 : 정상, 2 : 휴면, 3 : 탈퇴)
이메일인증여부(mail_auth_status) - 문자(1자), NN => 이메일 인증 기능 추가를 위한 인증 여부(Y, N)
-----------------------------------------
CREATE DATABASE spring_mvc_board5;
USE spring_mvc_board5;
CREATE TABLE member (
	idx INT PRIMARY KEY AUTO_INCREMENT,
 	name VARCHAR(10) NOT NULL,
 	id VARCHAR(16) NOT NULL UNIQUE,
 	passwd VARCHAR(100) NOT NULL,
 	jumin VARCHAR(14) NOT NULL UNIQUE,
 	post_code VARCHAR(10) NOT NULL,
 	address1 VARCHAR(100) NOT NULL,
 	address2 VARCHAR(100) NOT NULL,
 	email VARCHAR(50) NOT NULL UNIQUE,
 	job VARCHAR(10) NOT NULL,
 	gender VARCHAR(1) NOT NULL,
 	hobby VARCHAR(50) NOT NULL,
 	motivation VARCHAR(500) NOT NULL,
 	reg_date DATETIME NOT NULL,  => java.sql.Date 클래스 활용
 	member_status INT NOT NULL,
 	mail_auth_status VARCHAR(1) NOT NULL
);
*/

// Lombok을 활용하여 VO 클래스의 다양한 요소들을 자동으로 추가 가능
// => 각종 어노테이션을 사용하여 해당 항목 추가
//@Getter		=> Getter 메서드 자동 생성
//@Setter		=> Setter 메서드 자동 생성
//@ToString		=> ToString 메서드 자동 생성
//@AllArgsConstructor 		=> 모든 파라미터를 전달받는 파라미터 생성자 자동 생성
//@NoArgsConstructor 		=> 기본 생성자 자동 생성
@Data // => @Getter, @Setter, @ToString, @RequiredArgsConstructor 포함
public class MemberVO {
	// 1. 멤버변수 선언
//	private @Getter @Setter int idx; // 특정 변수만 Getter, Setter 생성 시
	private int idx;
	private String name;
	private String id;
	private String passwd;
	private String jumin;
	private String post_code;
	private String address1;
	private String address2;
	private String email;
	// ------- 분리된 주민번호, 이메일 주소 전달을 위한 멤버변수 추가 --------
	// DB 컬럼명은 jumin, email 이지만 입력폼 name 속성값이 일치하지 않으므로
	// 컨트롤러에서 해당 파라미터값을 자동 저장 불가능하므로 해당 변수 추가
	// => DB 에 INSERT 등의 작업 수행 시점에 결합하여 전달 예정
	private String jumin1;
	private String jumin2;
	private String email1;
	private String email2;
	// -----------------------------------------------------------------------
	private String job;
	private String gender;
	private String hobby;
	private String motivation;
	private Date reg_date; // java.sql.Date
	private int member_status; // 회원상태(1 : 정상, 2 : 휴면, 3 : 탈퇴)
	private String mail_auth_status;
}
