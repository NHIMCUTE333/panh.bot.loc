import React from 'react';
import { CheckCircle2 } from 'lucide-react';

interface ToastProps {
  message: string;
  isVisible: boolean;
}

export const Toast: React.FC<ToastProps> = ({ message, isVisible }) => {
  return (
    <div
      className={`fixed bottom-6 left-1/2 -translate-x-1/2 bg-[#333333] text-white px-5 py-2.5 rounded-full text-sm font-medium shadow-lg transition-all duration-300 pointer-events-none z-[99999] flex items-center gap-2 ${
        isVisible ? 'opacity-100 translate-y-0 scale-100' : 'opacity-0 translate-y-4 scale-95'
      }`}
    >
      <CheckCircle2 className="w-4 h-4 text-green-400" />
      <span>{message}</span>
    </div>
  );
};
