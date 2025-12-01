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
}
