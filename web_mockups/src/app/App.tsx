import { useState } from 'react';
import '@/styles/patterns.css';
import { HomePage } from './pages/HomePage';
import { ExplorePage } from './pages/ExplorePage';
import { StatsPage } from './pages/StatsPage';
import { ProfilePage } from './pages/ProfilePage';
import { LessonPathPage } from './pages/LessonPathPage';
import { InteractiveCardsPage } from './pages/InteractiveCardsPage';
import { CollectionPage } from './pages/CollectionPage';
import { BottomNav } from './components/organisms/BottomNav';
import { WorkoutPage } from './pages/WorkoutPage';
import { TrainingSessionPage } from './pages/TrainingSessionPage';
import { SettingsPage } from './pages/SettingsPage';
import { AchievementsPage } from './pages/AchievementsPage';

export default function App() {
  const [activeTab, setActiveTab] = useState('home');

  const renderPage = () => {
    switch (activeTab) {
      case 'home':
        return <HomePage onNavigate={setActiveTab} />;
      case 'learn':
        return <ExplorePage onNavigate={setActiveTab} />;
      case 'collection':
        return <CollectionPage onNavigate={setActiveTab} />;
      case 'workout':
        return <TrainingSessionPage onNavigate={setActiveTab} />;
      case 'profile':
        return <ProfilePage onNavigate={setActiveTab} />;
      // Sub-pages (hidden from bottom nav directly but reachable)
      case 'lesson-path':
        return <LessonPathPage onNavigate={setActiveTab} />;
      case 'ignite':
        return <InteractiveCardsPage onNavigate={setActiveTab} />;
      case 'training-session':
        return <TrainingSessionPage onNavigate={setActiveTab} />;
      case 'settings':
        return <SettingsPage onNavigate={setActiveTab} />;
      case 'achievements':
        return <AchievementsPage onNavigate={setActiveTab} />;
      default:
        return <HomePage />;
    }
  };

  return (
    <div className="relative min-h-screen w-full bg-bg-deep text-text-main overflow-hidden">
      {/* Background Effects */}
      <div className="fixed top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-0">
        <div className="absolute top-[-20%] left-[-20%] w-[600px] h-[600px] bg-forge-fire/10 rounded-full blur-[120px]" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[500px] h-[500px] bg-electric-blue/5 rounded-full blur-[100px]" />
      </div>

      {/* Main Content */}
      <div className={`relative z-10 max-w-[500px] mx-auto min-h-screen pb-32`}>
        {renderPage()}
      </div>

      {/* Bottom Navigation */}
      <BottomNav activeTab={activeTab} onTabChange={setActiveTab} />
    </div>
  );
}