-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
UISessionType =
{
    -- 可推出界面(UIMainMenu等)
    EUIST_Normal = 1,
    -- 固定窗口(UITopBar等)
    EUIST_Fixed = 2,
    -- 弹窗
    EUIST_PopUp = 3
}

UISessionShowMode =
{
    --
    EUISSM_DoNothing = 1,
    -- 关闭其他界面
    EUISSM_HideOther = 2,
    -- 点击返回按钮关闭当前,不关闭其他界面(需要调整好层级关系)
    EUISSM_NeedBack = 3,
    -- 关闭TopBar,关闭其他界面,不加入backSequence队列
    EUISSM_NoNeedBack = 4,
}

UISessionData = class()
function UISessionData:init(isStartWindow, sessionType, sessionShowMode)
    self.isStartWindow = isStartWindow
    self.sessionType = sessionType
    self.sessionShowMode = sessionShowMode
end

UIBackSessionSequenceData = class()
function UIBackSessionSequenceData:init(hideSession, backShowTargets)
    self.hideTargetSession = hideSession
    self.backShowTargets = backShowTargets
end

UIShowSessionData = class()
-- Reset窗口
-- Clear导航信息
-- Object 数据
function UIShowSessionData:init(isForceResetWindow, isForceClearBackSeqData, prefabName, sessionData)
    self.isForceResetWindow = isForceResetWindow
    self.isForceClearBackSeqData = isForceClearBackSeqData
    self.prefabName = prefabName
    self.sessionData = sessionData
end

UISession = class()
function UISession:init(sessionData)
    -- 如果需要可以添加一个BoxCollider屏蔽事件
    self.isLock = false
    self.isShown = false
    -- 当前界面ID
    self.sessionID = UISessionID.EUISID_Invaild
    -- 指向上一级界面ID(BackSequence无内容，返回上一级)
    self.preSessionID = UISessionID.EUISID_Invaild
    self.sessionData = sessionData
end

function UISession:OnPostLoad(gameObject)
    self.gameObject = gameObject
    self.transform = gameObject.transform
end

-- 重置窗口
function UISession:ResetWindow()
end

-- 显示窗口
function UISession:ShowSession()
end

-- 隐藏窗口
function UISession:HideSessionDirectly()
    self.isLock = true
    self.isShown = false
    if not tolua.isnull(self.gameObject) then
        self.gameObject:SetActive(false)
    end
end

function UISession:HideSession(hideHandler)
    self.isLock = true
    self.isShown = false
    if not tolua.isnull(self.gameObject) then
        self.gameObject:SetActive(false)
    end
    if hideHandler ~= nil then
        hideHandler()
    end
end

function UISession:OnPreDestory()
end

function UISession:DestroySession(beforeHandler)
    if beforeHandler ~= nil then
        beforeHandler()
    end
    UObject.Destroy(self.gameObject)
end


-- 能否添加到导航数据中
function UISession:CanAddedToBackSeq()
    if self.sessionData.sessionType == UISessionType.EUIST_PopUp then
        return false
    elseif self.sessionData.sessionType == UISessionType.EUIST_Fixed then
        return false
    elseif self.sessionData.sessionShowMode == UISessionShowMode.EUISSM_NoNeedBack then
        return false
    else
        return true
    end
end

function UISession:IsNeedRefreshBackSeqData()
    if self.sessionData.sessionShowMode == UISessionShowMode.EUISSM_HideOther
        or self.sessionData.sessionShowMode == UISessionShowMode.EUISSM_NeedBack then
        return true
    else
        return false
    end
end

function UISession:GetSessionID()
    return self.sessionID;
end
-- endregion