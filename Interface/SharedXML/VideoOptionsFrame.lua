function VideoOptionsFrame_Toggle ()
	ToggleFrame(VideoOptionsFrame);
end

function VideoOptionsFrame_SetAllToDefaults ()
	OptionsFrame_SetAllToDefaults(VideoOptionsFrame);
	VideoOptionsFrameApply:Disable();
end

function VideoOptionsFrame_SetCurrentToDefaults ()
	OptionsFrame_SetCurrentToDefaults(VideoOptionsFrame);
	VideoOptionsFrameApply:Disable();
end

function VideoOptionsFrame_OnLoad (self)
	OptionsFrame_OnLoad(self);
	self.Header:Setup(SYSTEMOPTIONS_MENU);
	if InGlue() then
		self:SetFrameStrata("DIALOG");
	end
end

function VideoOptionsFrame_OnShow (self)
	OptionsFrame_OnShow(self);
	if InGlue() then
		GlueParent_AddModalFrame(self);
	end	
end

function VideoOptionsFrame_OnHide (self)
	OptionsFrame_OnHide(self);
	VideoOptionsFrameApply:Disable();
	if ( VideoOptionsFrame.gameRestart ) then
		StaticPopup_Show("CLIENT_RESTART_ALERT");
		VideoOptionsFrame.gameRestart = nil;
	elseif ( VideoOptionsFrame.logout ) then
		StaticPopup_Show("CLIENT_LOGOUT_ALERT");
		VideoOptionsFrame.logout = nil;
	end

	if (not self.ignoreCancelOnHide) then
		OptionsFrameCancel_OnClick(VideoOptionsFrame);
	end

	if InGlue() then
		GlueParent_RemoveModalFrame(self);
	end	
end

function VideoOptionsFrameOkay_OnClick (self, button, down, apply)
	OptionsFrameOkay_OnClick(VideoOptionsFrame, apply);
	if ( not apply ) then
		VideoOptionsFrame.ignoreCancelOnHide = true;
		VideoOptionsFrame_Toggle();
		VideoOptionsFrame.ignoreCancelOnHide = nil;
	end
end

function VideoOptionsFrameCancel_OnClick (self, button)
	if ( VideoOptionsFrameApply:IsEnabled() ) then
		OptionsFrameCancel_OnClick(VideoOptionsFrame);
	end
	VideoOptionsFrame.logout = nil;
	VideoOptionsFrame_Toggle();
end

local StaticPopup_Show = StaticPopup_Show or GlueDialog_Show;

function VideoOptionsFrameDefault_OnClick (self, button)
	OptionsFrameDefault_OnClick(VideoOptionsFrame);

	StaticPopup_Show("CONFIRM_RESET_VIDEO_SETTINGS");
end
