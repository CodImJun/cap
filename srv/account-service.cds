using { app.service as db } from '../db/schema';

service AccountService {
  
  // 1. 계정 조회
  entity Accounts as projection on db.Accounts;
  
  // 2. 계정 중복 체크 (Custom Action)
  action checkAccountDuplicate(accountId: String, email: String) returns {
    isDuplicate: Boolean;
    message: String;
  };
  
  // 3. 가입 (Custom Action)
  action registerAccount(
    accountId: String,
    email: String,
    password: String,
    name: String
  ) returns {
    success: Boolean;
    accountID: String;
    message: String;
  };
  
  // 4. 가입 정보 조회
  entity Memberships as projection on db.Memberships {
    *,
    account.accountId as accountId,
    account.name as accountName,
    channel.channelId as channelId,
    channel.channelName as channelName
  };
  
  // 5. 채널 정보 조회
  entity Channels as projection on db.Channels;
  
  // 추가: 계정 활동 로그 조회
  entity AccountLogs as projection on db.AccountLogs {
    *,
    account.accountId as accountId,
    account.name as accountName
  };
  
  // 추가: 채널 초대 조회
  entity ChannelInvites as projection on db.ChannelInvites {
    *,
    channel.channelName as channelName,
    invitedBy.name as inviterName
  };
}
