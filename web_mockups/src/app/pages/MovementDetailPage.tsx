import { useState } from 'react';
import { Header } from '@/app/components/organisms/Header';
import { MovementCard } from '@/app/components/organisms/MovementCard';
import { PaginationDot } from '@/app/components/atoms/PaginationDot';

export const MovementDetailPage = () => {
  const [currentCard, setCurrentCard] = useState(0);

  const movements = [
    {
      title: 'THE 6-STEP',
      category: 'Power Move',
      tags: ['Footwork', 'Foundation'],
      bpm: 102,
      rhythm: 'Syncopated',
      imageUrl: 'https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=800&auto=format&fit=crop&q=80'
    },
    {
      title: 'THE WINDMILL',
      category: 'Power Move',
      tags: ['Rotation', 'Advanced'],
      bpm: 110,
      rhythm: 'Continuous',
      imageUrl: 'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&auto=format&fit=crop&q=80'
    },
    {
      title: 'FREEZE COMBO',
      category: 'Technique',
      tags: ['Balance', 'Strength'],
      bpm: 95,
      rhythm: 'Variable',
      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&auto=format&fit=crop&q=80'
    }
  ];

  return (
    <div className="relative flex h-screen w-full flex-col max-w-md mx-auto overflow-hidden bg-bg-deep">
      <Header
        title="Movement Card"
        subtitle="Collection"
        onBack={() => console.log('Back')}
        onMore={() => console.log('More')}
      />

      {/* Pagination Dots */}
      <div className="flex w-full flex-row items-center justify-center gap-2 px-6 py-2 z-10">
        {movements.map((_, idx) => (
          <PaginationDot key={idx} active={idx === currentCard} variant="bar" />
        ))}
      </div>

      {/* Movement Card */}
      <main className="flex-1 relative flex items-center justify-center w-full px-4 pb-4 pt-2">
        <MovementCard
          {...movements[currentCard]}
          onFlip={() => console.log('Flip')}
          onRecord={() => console.log('Record')}
          className="max-h-[calc(100vh-200px)]"
        />
      </main>
    </div>
  );
};
