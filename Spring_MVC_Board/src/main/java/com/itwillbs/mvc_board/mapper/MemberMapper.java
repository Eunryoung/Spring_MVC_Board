package com.itwillbs.mvc_board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.mvc_board.vo.MemberVO;

@Mapper
public interface MemberMapper {
	
	// 회원 가입
	public abstract int insertMember(MemberVO member);

	// 회원 상세정보 조회
	public abstract MemberVO selectMember(MemberVO member);

	// 회원정보 수정
	// => 주의! 파라미터가 복수개일 경우 @Param 어노테이션 사용하여 파라미터 이름 지정 필수!
	public abstract int updateMember(@Param("member") MemberVO member, @Param("newPasswd") String newPasswd);

	// 회원 탈퇴
	public abstract int updateMemberStatus(MemberVO member);

	// 관리자 - 회원 목록 조회
	public abstract List<MemberVO> selectMemberList();

}
