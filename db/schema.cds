using { cuid, managed } from '@sap/cds/common';

namespace app.service;

/**
 * 계정 정보 테이블
 */
entity Accounts : cuid, managed {
  accountId    : String(100) @mandatory;  // 계정 ID (unique)
  email        : String(255) @mandatory;  // 이메일
  password     : String(255) @mandatory;  // 비밀번호 (해시)
  name         : String(100) @mandatory;  // 이름
}

/**
 * 채널 정보 테이블
 */
entity Channels : cuid, managed {
  channelId       : String(100) @mandatory;  // 채널 ID (unique)
  channelName     : String(200) @mandatory;  // 채널 이름
  autoJoinEnabled : Boolean default false;   // 자동 가입 허용
  manualJoinEnabled : Boolean default true;  // 수동 가입 허용
}

/**
 * 가입 정보 테이블
 */
entity Memberships : cuid, managed {
  account       : Association to Accounts @mandatory;
  channel       : Association to Channels @mandatory;
  joinType      : String(20) @mandatory;  // AUTO 또는 MANUAL
}
