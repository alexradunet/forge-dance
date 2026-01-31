import { Icon } from '@/app/components/atoms/Icon';
import { Header } from '@/app/components/organisms/Header';

interface SettingsPageProps {
  onNavigate?: (page: string) => void;
}

export const SettingsPage = ({ onNavigate }: SettingsPageProps) => {
  return (
    <main className="flex-1 flex flex-col z-10 overflow-hidden relative w-full max-w-md mx-auto">
      {/* Background gradient effects */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-0">
        <div className="absolute top-[-15%] right-[-20%] w-[400px] h-[400px] bg-forge-fire/10 rounded-full blur-[100px]" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[300px] h-[300px] bg-electric-blue/5 rounded-full blur-[80px]" />
      </div>

      <Header 
        title="SETTINGS" 
        leftSlot={
          <button 
            onClick={() => onNavigate?.('profile')}
            className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-white/10 transition-colors text-text-muted hover:text-white"
          >
            <Icon name="arrow_back" className="text-2xl" />
          </button>
        }
      />

      <div className="flex-1 overflow-y-auto overflow-x-hidden scrollbar-hide pb-32 relative z-10 px-6 mt-6">
        {/* Account Section */}
        <div className="mb-6">
          <h3 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3 px-2">
            Account
          </h3>
          <div className="bg-surface-card border border-white/5 rounded-2xl shadow-lg overflow-hidden">
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="person" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Edit Profile</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="lock" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Change Password</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="email" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Email Preferences</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
          </div>
        </div>

        {/* Preferences Section */}
        <div className="mb-6">
          <h3 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3 px-2">
            Preferences
          </h3>
          <div className="bg-surface-card border border-white/5 rounded-2xl shadow-lg overflow-hidden">
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="notifications" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Notifications</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="language" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Language</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-xs text-text-muted">English</span>
                <Icon name="chevron_right" className="text-xl text-text-muted" />
              </div>
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="palette" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Theme</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-xs text-text-muted">Dark</span>
                <Icon name="chevron_right" className="text-xl text-text-muted" />
              </div>
            </button>
          </div>
        </div>

        {/* Privacy & Security Section */}
        <div className="mb-6">
          <h3 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3 px-2">
            Privacy & Security
          </h3>
          <div className="bg-surface-card border border-white/5 rounded-2xl shadow-lg overflow-hidden">
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="shield" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Privacy Settings</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="security" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Two-Factor Authentication</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="block" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Blocked Users</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
          </div>
        </div>

        {/* About Section */}
        <div className="mb-6">
          <h3 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3 px-2">
            About
          </h3>
          <div className="bg-surface-card border border-white/5 rounded-2xl shadow-lg overflow-hidden">
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="help" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Help & Support</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="article" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Terms of Service</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="policy" className="text-xl text-text-muted" />
                <span className="text-sm text-white">Privacy Policy</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-text-muted" />
            </button>
            <div className="h-[1px] bg-white/5 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-white/5 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="info" className="text-xl text-text-muted" />
                <span className="text-sm text-white">About Forge.Dance</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-xs text-text-muted">v1.0.0</span>
                <Icon name="chevron_right" className="text-xl text-text-muted" />
              </div>
            </button>
          </div>
        </div>

        {/* Danger Zone */}
        <div className="mb-6">
          <h3 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3 px-2">
            Danger Zone
          </h3>
          <div className="bg-surface-card border border-red-500/20 rounded-2xl shadow-lg overflow-hidden">
            <button className="w-full flex items-center justify-between p-4 hover:bg-red-500/10 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="logout" className="text-xl text-red-500" />
                <span className="text-sm text-red-500">Log Out</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-red-500/50" />
            </button>
            <div className="h-[1px] bg-red-500/20 mx-4" />
            <button className="w-full flex items-center justify-between p-4 hover:bg-red-500/10 transition-colors">
              <div className="flex items-center gap-3">
                <Icon name="delete_forever" className="text-xl text-red-500" />
                <span className="text-sm text-red-500">Delete Account</span>
              </div>
              <Icon name="chevron_right" className="text-xl text-red-500/50" />
            </button>
          </div>
        </div>
      </div>
    </main>
  );
};
