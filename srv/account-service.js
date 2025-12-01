const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Accounts, Memberships, Channels } = this.entities;

  // 2. 계정 중복 체크
  this.on('checkAccountDuplicate', async (req) => {
    const { accountId, email } = req.data;
    
    // accountId 또는 email로 중복 체크
    const existingAccount = await SELECT.one.from(Accounts).where({
      or: [
        { accountId: accountId },
        { email: email }
      ]
    });

    if (existingAccount) {
      return {
        isDuplicate: true,
        message: '이미 존재하는 계정 ID 또는 이메일입니다.'
      };
    }

    return {
      isDuplicate: false,
      message: '사용 가능한 계정입니다.'
    };
  });

  // 3. 가입
  this.on('registerAccount', async (req) => {
    const { accountId, email, password, name } = req.data;

    try {
      // 중복 체크
      const existingAccount = await SELECT.one.from(Accounts).where({
        or: [
          { accountId: accountId },
          { email: email }
        ]
      });

      if (existingAccount) {
        return {
          success: false,
          accountID: null,
          message: '이미 존재하는 계정 ID 또는 이메일입니다.'
        };
      }

      // 비밀번호 해시 처리 (실제로는 bcrypt 등을 사용해야 함)
      // const hashedPassword = await hashPassword(password);
      
      // 계정 생성
      const newAccount = await INSERT.into(Accounts).entries({
        accountId,
        email,
        password: password, // 실제로는 hashedPassword 사용
        name
      });

      return {
        success: true,
        accountID: accountId,
        message: '계정이 성공적으로 생성되었습니다.'
      };

    } catch (error) {
      console.error('계정 생성 오류:', error);
      return {
        success: false,
        accountID: null,
        message: '계정 생성 중 오류가 발생했습니다.'
      };
    }
  });

  // 1. 계정 조회 - 비밀번호 필드 제외
  this.after('READ', Accounts, (accounts) => {
    if (Array.isArray(accounts)) {
      accounts.forEach(account => delete account.password);
    } else if (accounts) {
      delete accounts.password;
    }
    return accounts;
  });

  // 4. 가입 정보 조회 - expand로 관련 정보 자동 포함
  this.on('READ', Memberships, async (req, next) => {
    // 기본 동작 수행
    const result = await next();
    return result;
  });

  // 5. 채널 정보 조회 - 기본 CRUD 제공됨
  this.on('READ', Channels, async (req, next) => {
    const result = await next();
    return result;
  });

});
