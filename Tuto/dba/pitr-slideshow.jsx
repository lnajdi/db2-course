import { useState, useEffect } from 'react';

const slides = [
  {
    id: 'intro',
    title: 'Point-in-Time Recovery',
    subtitle: 'Travel back to any moment in your database',
    type: 'title'
  },
  {
    id: 'scenario',
    title: 'The Disaster',
    subtitle: 'A developer\'s worst nightmare',
    content: {
      time: '3:42 PM',
      command: 'DELETE FROM users;',
      note: '(forgot the WHERE clause)',
      result: '50,000 users deleted instantly'
    },
    type: 'scenario'
  },
  {
    id: 'backup-problem',
    title: 'Traditional Backups',
    subtitle: 'Why they\'re not enough',
    content: {
      timeline: [
        { time: 'Mon 2AM', event: 'Backup', type: 'backup' },
        { time: 'Tue 2AM', event: 'Backup', type: 'backup' },
        { time: 'Wed 2AM', event: 'Backup', type: 'backup' },
        { time: 'Wed 3:42PM', event: '💥 DELETE', type: 'disaster' },
      ],
      problem: 'Last backup was 13 hours ago. All changes since then are LOST.'
    },
    type: 'backup-problem'
  },
  {
    id: 'solution',
    title: 'The Solution: PITR',
    subtitle: 'Point-in-Time Recovery',
    content: {
      definition: 'Restore your database to ANY specific moment in time',
      precision: 'Down to the exact second',
      example: 'Recover to 3:41:59 PM — one second before disaster'
    },
    type: 'solution'
  },
  {
    id: 'components',
    title: 'PITR Components',
    subtitle: 'What makes it possible',
    content: {
      parts: [
        { icon: '📦', name: 'Base Backup', desc: 'Full database snapshot' },
        { icon: '📝', name: 'WAL Archive', desc: 'Continuous transaction logs' },
        { icon: '🎯', name: 'Target Time', desc: 'When to stop replay' },
      ]
    },
    type: 'components'
  },
  {
    id: 'base-backup',
    title: 'Base Backup',
    subtitle: 'The starting point',
    content: {
      what: 'A complete copy of your database at a specific moment',
      when: 'Taken periodically (daily, weekly)',
      includes: ['All tables', 'All indexes', 'All data files', 'Checkpoint position']
    },
    type: 'base-backup'
  },
  {
    id: 'wal-archive',
    title: 'WAL Archiving',
    subtitle: 'Recording every change',
    content: {
      flow: [
        { step: 1, action: 'Transaction executes' },
        { step: 2, action: 'Written to WAL' },
        { step: 3, action: 'WAL segment fills up' },
        { step: 4, action: 'Archived to safe storage' },
      ],
      key: 'Every change is preserved forever'
    },
    type: 'wal-archive'
  },
  {
    id: 'timeline',
    title: 'The Recovery Timeline',
    subtitle: 'How all pieces fit together',
    content: {
      segments: [
        { label: 'Base Backup', time: 'Mon 2AM', type: 'backup' },
        { label: 'WAL 001', time: '', type: 'wal' },
        { label: 'WAL 002', time: '', type: 'wal' },
        { label: 'WAL 003', time: '', type: 'wal' },
        { label: 'WAL 004', time: '', type: 'wal' },
        { label: 'Target', time: '3:41 PM', type: 'target' },
        { label: '💥', time: '3:42 PM', type: 'disaster' },
      ]
    },
    type: 'timeline'
  },
  {
    id: 'recovery-steps',
    title: 'Recovery Process',
    subtitle: 'Step by step',
    content: {
      steps: [
        'Stop the database',
        'Restore base backup',
        'Configure recovery target time',
        'Replay WAL until target',
        'Database is recovered!'
      ]
    },
    type: 'recovery-steps'
  },
  {
    id: 'replay-animation',
    title: 'WAL Replay',
    subtitle: 'Rebuilding history',
    type: 'replay-animation'
  },
  {
    id: 'target-options',
    title: 'Recovery Targets',
    subtitle: 'Different ways to specify "when"',
    content: {
      options: [
        { type: 'Time', example: "2024-03-15 15:41:59", desc: 'Exact timestamp' },
        { type: 'Transaction ID', example: 'XID 12345678', desc: 'Specific transaction' },
        { type: 'Named Point', example: 'before_migration', desc: 'Custom restore point' },
        { type: 'LSN', example: '0/16B3748', desc: 'Log sequence number' },
      ]
    },
    type: 'target-options'
  },
  {
    id: 'use-cases',
    title: 'When to Use PITR',
    subtitle: 'Real-world scenarios',
    content: {
      cases: [
        { icon: '🗑️', title: 'Accidental DELETE', desc: 'Forgot WHERE clause' },
        { icon: '💾', title: 'Bad Deployment', desc: 'Migration corrupted data' },
        { icon: '🔒', title: 'Ransomware', desc: 'Recover pre-attack state' },
        { icon: '🐛', title: 'Bug Discovery', desc: 'Data corrupted over time' },
      ]
    },
    type: 'use-cases'
  },
  {
    id: 'comparison',
    title: 'PITR vs Regular Backup',
    subtitle: 'Side by side',
    content: {
      regular: {
        title: 'Regular Backup',
        points: ['Fixed restore points', 'Hours/days of data loss', 'Simple to manage', 'Less storage needed']
      },
      pitr: {
        title: 'PITR',
        points: ['Any point in time', 'Seconds of data loss', 'More complex setup', 'More storage for WAL']
      }
    },
    type: 'comparison'
  },
  {
    id: 'rpo',
    title: 'Recovery Point Objective',
    subtitle: 'How much data can you afford to lose?',
    content: {
      levels: [
        { rpo: '24 hours', method: 'Daily backups', cost: '$' },
        { rpo: '1 hour', method: 'Hourly backups', cost: '$$' },
        { rpo: 'Seconds', method: 'PITR with WAL', cost: '$$$' },
        { rpo: 'Zero', method: 'Sync replication', cost: '$$$$' },
      ]
    },
    type: 'rpo'
  },
  {
    id: 'requirements',
    title: 'PITR Requirements',
    subtitle: 'What you need',
    content: {
      items: [
        { icon: '✓', text: 'WAL archiving enabled' },
        { icon: '✓', text: 'Regular base backups' },
        { icon: '✓', text: 'Secure archive storage' },
        { icon: '✓', text: 'Monitoring & alerts' },
        { icon: '✓', text: 'Tested recovery process' },
      ]
    },
    type: 'requirements'
  },
  {
    id: 'storage',
    title: 'Storage Considerations',
    subtitle: 'WAL adds up fast',
    content: {
      example: {
        activity: '100 transactions/second',
        walSize: '~16MB per WAL segment',
        perDay: '~2-5 GB of WAL per day',
        retention: '7 days = 14-35 GB'
      },
      tip: 'Balance retention period with storage costs'
    },
    type: 'storage'
  },
  {
    id: 'real-world',
    title: 'Database Support',
    subtitle: 'PITR is everywhere',
    content: {
      databases: [
        { name: 'PostgreSQL', cmd: 'pg_basebackup + archive_command' },
        { name: 'MySQL', cmd: 'Binary log + mysqlbinlog' },
        { name: 'SQL Server', cmd: 'Full + Transaction log backups' },
        { name: 'Oracle', cmd: 'RMAN + Archive logs' },
      ]
    },
    type: 'real-world'
  },
  {
    id: 'best-practices',
    title: 'Best Practices',
    subtitle: 'Do it right',
    content: {
      practices: [
        'Test recovery regularly',
        'Monitor WAL archiving lag',
        'Store archives off-site',
        'Document recovery steps',
        'Know your RPO/RTO goals',
        'Automate base backups',
      ]
    },
    type: 'best-practices'
  },
  {
    id: 'summary',
    title: 'Summary',
    subtitle: 'Key takeaways',
    content: {
      points: [
        'PITR = Base Backup + WAL Archive',
        'Recover to any second in time',
        'Protects against human error',
        'Requires continuous WAL archiving',
        'Test your recovery process!',
      ]
    },
    type: 'summary'
  },
  {
    id: 'demo',
    title: 'Live Demo',
    subtitle: 'See PITR in action',
    type: 'demo'
  }
];

// Slide Components
function TitleSlide({ slide }) {
  return (
    <div style={{ textAlign: 'center', padding: '60px 40px' }}>
      <div style={{
        fontSize: '4rem',
        marginBottom: '20px',
      }}>
        ⏪
      </div>
      <h1 style={{
        fontSize: '3.2rem',
        fontWeight: 800,
        color: '#1a1a2e',
        marginBottom: '16px',
        letterSpacing: '-0.03em',
      }}>
        {slide.title}
      </h1>
      <p style={{
        fontSize: '1.4rem',
        color: '#6b7280',
        fontWeight: 400,
      }}>
        {slide.subtitle}
      </p>
      <div style={{
        marginTop: '50px',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        gap: '16px',
      }}>
        {['📦', '+', '📝', '=', '🎯'].map((icon, i) => (
          <span key={i} style={{
            fontSize: icon.length === 1 ? '1.5rem' : '2.5rem',
            color: icon.length === 1 ? '#9ca3af' : 'inherit',
            animation: `fadeIn 0.5s ease ${i * 0.15}s both`,
          }}>
            {icon}
          </span>
        ))}
      </div>
    </div>
  );
}

function ScenarioSlide({ slide }) {
  const [phase, setPhase] = useState(0);
  
  useEffect(() => {
    const timers = [
      setTimeout(() => setPhase(1), 500),
      setTimeout(() => setPhase(2), 1500),
      setTimeout(() => setPhase(3), 2500),
    ];
    return () => timers.forEach(clearTimeout);
  }, []);

  return (
    <div style={{ padding: '40px', textAlign: 'center' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px' }}>{slide.subtitle}</p>
      
      <div style={{
        maxWidth: '500px',
        margin: '0 auto',
      }}>
        <div style={{
          background: '#1a1a2e',
          borderRadius: '12px',
          padding: '24px',
          marginBottom: '24px',
          fontFamily: 'monospace',
          textAlign: 'left',
        }}>
          <div style={{ color: '#6b7280', marginBottom: '8px', opacity: phase >= 1 ? 1 : 0, transition: 'opacity 0.3s' }}>
            postgres=# <span style={{ color: '#ef4444' }}>{slide.content.command}</span>
          </div>
          {phase >= 2 && (
            <div style={{ color: '#fbbf24', fontSize: '0.85rem', marginTop: '12px' }}>
              {slide.content.note}
            </div>
          )}
        </div>
        
        {phase >= 3 && (
          <div style={{
            background: '#fef2f2',
            border: '2px solid #ef4444',
            borderRadius: '12px',
            padding: '24px',
            animation: 'shake 0.5s ease',
          }}>
            <div style={{ fontSize: '3rem', marginBottom: '12px' }}>😱</div>
            <div style={{ color: '#dc2626', fontWeight: 700, fontSize: '1.2rem' }}>
              {slide.content.result}
            </div>
            <div style={{ color: '#991b1b', marginTop: '8px', fontSize: '0.9rem' }}>
              Time: {slide.content.time}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function BackupProblemSlide({ slide }) {
  const [highlight, setHighlight] = useState(-1);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setHighlight(h => h < slide.content.timeline.length - 1 ? h + 1 : h);
    }, 700);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'flex-end',
        gap: '24px',
        marginBottom: '40px',
        padding: '20px',
      }}>
        {slide.content.timeline.map((item, i) => (
          <div key={i} style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '12px',
            opacity: i <= highlight ? 1 : 0.3,
            transition: 'all 0.3s ease',
          }}>
            <div style={{
              width: '60px',
              height: item.type === 'backup' ? '80px' : '100px',
              background: item.type === 'disaster' ? '#fef2f2' : '#f0fdf4',
              border: `2px solid ${item.type === 'disaster' ? '#ef4444' : '#22c55e'}`,
              borderRadius: '8px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: item.type === 'disaster' ? '1.5rem' : '1rem',
            }}>
              {item.type === 'backup' ? '📦' : '💥'}
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '0.75rem',
                color: '#6b7280',
              }}>
                {item.time}
              </div>
              <div style={{
                fontSize: '0.85rem',
                fontWeight: 600,
                color: item.type === 'disaster' ? '#dc2626' : '#166534',
              }}>
                {item.event}
              </div>
            </div>
          </div>
        ))}
      </div>
      
      <div style={{
        background: '#fef2f2',
        border: '2px solid #fca5a5',
        borderRadius: '12px',
        padding: '20px',
        maxWidth: '500px',
        margin: '0 auto',
        textAlign: 'center',
      }}>
        <span style={{ color: '#dc2626', fontWeight: 600 }}>
          ⚠️ {slide.content.problem}
        </span>
      </div>
    </div>
  );
}

function SolutionSlide({ slide }) {
  return (
    <div style={{ padding: '40px', textAlign: 'center' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px' }}>{slide.subtitle}</p>
      
      <div style={{
        maxWidth: '550px',
        margin: '0 auto',
      }}>
        <div style={{
          background: 'linear-gradient(135deg, #dbeafe, #ede9fe)',
          borderRadius: '20px',
          padding: '40px',
          marginBottom: '24px',
        }}>
          <p style={{
            fontSize: '1.5rem',
            color: '#1e3a5f',
            fontWeight: 600,
            lineHeight: 1.5,
            marginBottom: '16px',
          }}>
            {slide.content.definition}
          </p>
          <p style={{
            fontSize: '1.1rem',
            color: '#4338ca',
            fontWeight: 500,
          }}>
            ⏱️ {slide.content.precision}
          </p>
        </div>
        
        <div style={{
          background: '#f0fdf4',
          border: '2px solid #22c55e',
          borderRadius: '12px',
          padding: '20px',
        }}>
          <span style={{ color: '#166534', fontWeight: 600 }}>
            ✓ {slide.content.example}
          </span>
        </div>
      </div>
    </div>
  );
}

function ComponentsSlide({ slide }) {
  const [active, setActive] = useState(-1);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setActive(a => a < slide.content.parts.length - 1 ? a + 1 : a);
    }, 600);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        gap: '24px',
        flexWrap: 'wrap',
      }}>
        {slide.content.parts.map((part, i) => (
          <div key={i} style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '8px',
          }}>
            <div style={{
              width: '120px',
              height: '120px',
              borderRadius: '20px',
              background: i <= active ? 'linear-gradient(135deg, #dbeafe, #ede9fe)' : '#f9fafb',
              border: `2px solid ${i <= active ? '#6366f1' : '#e5e7eb'}`,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px',
              opacity: i <= active ? 1 : 0.4,
              transform: i <= active ? 'scale(1)' : 'scale(0.95)',
              transition: 'all 0.4s ease',
            }}>
              <span style={{ fontSize: '2.5rem' }}>{part.icon}</span>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{ fontWeight: 700, color: '#1a1a2e', fontSize: '0.95rem' }}>{part.name}</div>
              <div style={{ color: '#6b7280', fontSize: '0.8rem' }}>{part.desc}</div>
            </div>
            {i < slide.content.parts.length - 1 && (
              <div style={{
                position: 'absolute',
                fontSize: '1.5rem',
                color: '#d1d5db',
                transform: 'translateX(70px)',
              }}>
                +
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

function BaseBackupSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        maxWidth: '500px',
        margin: '0 auto',
      }}>
        <div style={{
          background: '#f0fdf4',
          border: '2px solid #22c55e',
          borderRadius: '16px',
          padding: '24px',
          marginBottom: '24px',
          textAlign: 'center',
        }}>
          <div style={{ fontSize: '3rem', marginBottom: '12px' }}>📦</div>
          <p style={{ color: '#166534', fontWeight: 500, fontSize: '1.1rem' }}>
            {slide.content.what}
          </p>
          <p style={{ color: '#6b7280', marginTop: '8px', fontSize: '0.9rem' }}>
            {slide.content.when}
          </p>
        </div>
        
        <div style={{
          background: '#f9fafb',
          borderRadius: '12px',
          padding: '20px',
        }}>
          <div style={{ fontWeight: 600, color: '#374151', marginBottom: '12px' }}>Contains:</div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
            {slide.content.includes.map((item, i) => (
              <span key={i} style={{
                padding: '8px 16px',
                background: '#e5e7eb',
                borderRadius: '20px',
                fontSize: '0.85rem',
                color: '#4b5563',
              }}>
                {item}
              </span>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

function WALArchiveSlide({ slide }) {
  const [step, setStep] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setStep(s => s < slide.content.flow.length ? s + 1 : s);
    }, 700);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '16px',
        maxWidth: '400px',
        margin: '0 auto 30px',
      }}>
        {slide.content.flow.map((item, i) => (
          <div key={i} style={{
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
            padding: '16px 20px',
            background: i < step ? '#f0fdf4' : '#f9fafb',
            border: i < step ? '2px solid #22c55e' : '2px solid #e5e7eb',
            borderRadius: '12px',
            opacity: i < step ? 1 : 0.4,
            transform: i < step ? 'translateX(0)' : 'translateX(-20px)',
            transition: 'all 0.3s ease',
          }}>
            <div style={{
              width: '32px',
              height: '32px',
              borderRadius: '50%',
              background: i < step ? '#22c55e' : '#e5e7eb',
              color: i < step ? '#fff' : '#9ca3af',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
            }}>
              {item.step}
            </div>
            <span style={{ color: '#374151', fontWeight: 500 }}>{item.action}</span>
          </div>
        ))}
      </div>
      
      <div style={{
        background: 'linear-gradient(135deg, #dbeafe, #ede9fe)',
        borderRadius: '12px',
        padding: '16px 24px',
        maxWidth: '400px',
        margin: '0 auto',
        textAlign: 'center',
      }}>
        <span style={{ color: '#4338ca', fontWeight: 600 }}>
          💡 {slide.content.key}
        </span>
      </div>
    </div>
  );
}

function TimelineSlide({ slide }) {
  const [progress, setProgress] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setProgress(p => p < slide.content.segments.length ? p + 1 : p);
    }, 500);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '4px',
        padding: '20px',
        overflowX: 'auto',
      }}>
        {slide.content.segments.map((seg, i) => (
          <div key={i} style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '8px',
            opacity: i < progress ? 1 : 0.3,
            transition: 'opacity 0.3s ease',
          }}>
            <div style={{
              width: seg.type === 'backup' ? '60px' : seg.type === 'target' ? '50px' : seg.type === 'disaster' ? '50px' : '50px',
              height: '50px',
              borderRadius: '8px',
              background: seg.type === 'backup' ? '#dbeafe' :
                         seg.type === 'wal' ? '#fef3c7' :
                         seg.type === 'target' ? '#dcfce7' : '#fee2e2',
              border: `2px solid ${
                seg.type === 'backup' ? '#3b82f6' :
                seg.type === 'wal' ? '#f59e0b' :
                seg.type === 'target' ? '#22c55e' : '#ef4444'
              }`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: seg.type === 'disaster' ? '1.3rem' : '0.7rem',
              fontWeight: 600,
              color: seg.type === 'backup' ? '#1d4ed8' :
                     seg.type === 'wal' ? '#92400e' :
                     seg.type === 'target' ? '#166534' : '#dc2626',
            }}>
              {seg.label}
            </div>
            <div style={{
              fontSize: '0.7rem',
              color: '#6b7280',
              height: '16px',
            }}>
              {seg.time}
            </div>
          </div>
        ))}
      </div>
      
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        gap: '20px',
        marginTop: '30px',
        flexWrap: 'wrap',
      }}>
        {[
          { color: '#3b82f6', label: 'Base Backup' },
          { color: '#f59e0b', label: 'WAL Segments' },
          { color: '#22c55e', label: 'Recovery Target' },
        ].map((item, i) => (
          <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <div style={{ width: '12px', height: '12px', borderRadius: '3px', background: item.color }} />
            <span style={{ fontSize: '0.85rem', color: '#6b7280' }}>{item.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function RecoveryStepsSlide({ slide }) {
  const [step, setStep] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setStep(s => s < slide.content.steps.length ? s + 1 : s);
    }, 700);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '16px',
        maxWidth: '450px',
        margin: '0 auto',
      }}>
        {slide.content.steps.map((s, i) => (
          <div key={i} style={{
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
            padding: '18px 22px',
            background: i < step ? (i === slide.content.steps.length - 1 ? '#f0fdf4' : '#f9fafb') : '#f9fafb',
            border: i < step ? 
              (i === slide.content.steps.length - 1 ? '2px solid #22c55e' : '2px solid #6366f1') : 
              '2px solid #e5e7eb',
            borderRadius: '12px',
            opacity: i < step ? 1 : 0.4,
            transform: i < step ? 'translateX(0)' : 'translateX(-20px)',
            transition: 'all 0.3s ease',
          }}>
            <div style={{
              width: '36px',
              height: '36px',
              borderRadius: '50%',
              background: i < step ? 
                (i === slide.content.steps.length - 1 ? '#22c55e' : '#6366f1') : 
                '#e5e7eb',
              color: i < step ? '#fff' : '#9ca3af',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
            }}>
              {i === slide.content.steps.length - 1 && i < step ? '✓' : i + 1}
            </div>
            <span style={{ 
              color: '#374151', 
              fontWeight: i === slide.content.steps.length - 1 && i < step ? 700 : 500,
              color: i === slide.content.steps.length - 1 && i < step ? '#166534' : '#374151',
            }}>
              {s}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

function ReplayAnimationSlide() {
  const [phase, setPhase] = useState(0);
  const walSegments = ['WAL 001', 'WAL 002', 'WAL 003', 'WAL 004'];
  
  useEffect(() => {
    const timer = setInterval(() => {
      setPhase(p => (p + 1) % 6);
    }, 1200);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>WAL Replay</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>Rebuilding history</p>
      
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        gap: '40px',
        marginBottom: '30px',
      }}>
        {/* Base Backup */}
        <div style={{
          textAlign: 'center',
        }}>
          <div style={{
            width: '80px',
            height: '80px',
            background: phase >= 1 ? '#dbeafe' : '#f3f4f6',
            border: `3px solid ${phase >= 1 ? '#3b82f6' : '#e5e7eb'}`,
            borderRadius: '12px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '2rem',
            transition: 'all 0.3s ease',
          }}>
            📦
          </div>
          <div style={{ marginTop: '8px', fontSize: '0.85rem', color: '#6b7280' }}>Base Backup</div>
        </div>
        
        <div style={{ fontSize: '2rem', color: '#d1d5db' }}>→</div>
        
        {/* WAL Segments */}
        <div style={{
          display: 'flex',
          gap: '8px',
        }}>
          {walSegments.map((wal, i) => (
            <div key={i} style={{
              width: '60px',
              height: '60px',
              background: phase >= i + 2 ? '#fef3c7' : '#f3f4f6',
              border: `2px solid ${phase >= i + 2 ? '#f59e0b' : '#e5e7eb'}`,
              borderRadius: '8px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '0.7rem',
              fontWeight: 600,
              color: phase >= i + 2 ? '#92400e' : '#9ca3af',
              transition: 'all 0.3s ease',
              transform: phase === i + 2 ? 'scale(1.1)' : 'scale(1)',
            }}>
              {wal}
            </div>
          ))}
        </div>
        
        <div style={{ fontSize: '2rem', color: '#d1d5db' }}>→</div>
        
        {/* Recovered DB */}
        <div style={{
          textAlign: 'center',
        }}>
          <div style={{
            width: '80px',
            height: '80px',
            background: phase >= 5 ? '#dcfce7' : '#f3f4f6',
            border: `3px solid ${phase >= 5 ? '#22c55e' : '#e5e7eb'}`,
            borderRadius: '12px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '2rem',
            transition: 'all 0.3s ease',
          }}>
            🗄️
          </div>
          <div style={{ marginTop: '8px', fontSize: '0.85rem', color: '#6b7280' }}>Recovered</div>
        </div>
      </div>
      
      <div style={{
        textAlign: 'center',
        padding: '16px',
        background: '#f9fafb',
        borderRadius: '8px',
        maxWidth: '400px',
        margin: '0 auto',
      }}>
        <span style={{ color: '#4b5563', fontWeight: 500 }}>
          {phase === 0 && 'Starting recovery...'}
          {phase === 1 && 'Restoring base backup...'}
          {phase === 2 && 'Replaying WAL 001...'}
          {phase === 3 && 'Replaying WAL 002...'}
          {phase === 4 && 'Replaying WAL 003, 004...'}
          {phase === 5 && '✅ Recovery complete at target time!'}
        </span>
      </div>
    </div>
  );
}

function TargetOptionsSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        gap: '16px',
        maxWidth: '600px',
        margin: '0 auto',
      }}>
        {slide.content.options.map((opt, i) => (
          <div key={i} style={{
            padding: '20px',
            background: '#f9fafb',
            borderRadius: '12px',
            border: '1px solid #e5e7eb',
          }}>
            <div style={{
              fontWeight: 700,
              color: '#4338ca',
              marginBottom: '8px',
              fontSize: '0.95rem',
            }}>
              {opt.type}
            </div>
            <code style={{
              display: 'block',
              background: '#e5e7eb',
              padding: '8px 12px',
              borderRadius: '6px',
              fontSize: '0.8rem',
              color: '#374151',
              marginBottom: '8px',
            }}>
              {opt.example}
            </code>
            <div style={{ color: '#6b7280', fontSize: '0.85rem' }}>
              {opt.desc}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function UseCasesSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        gap: '20px',
        maxWidth: '600px',
        margin: '0 auto',
      }}>
        {slide.content.cases.map((c, i) => (
          <div key={i} style={{
            padding: '24px',
            background: 'linear-gradient(135deg, #faf5ff, #eff6ff)',
            borderRadius: '16px',
            border: '1px solid #c7d2fe',
            textAlign: 'center',
          }}>
            <div style={{ fontSize: '2.5rem', marginBottom: '12px' }}>{c.icon}</div>
            <div style={{ fontWeight: 700, color: '#1a1a2e', marginBottom: '6px' }}>{c.title}</div>
            <div style={{ color: '#6b7280', fontSize: '0.9rem' }}>{c.desc}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

function ComparisonSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: '1fr 1fr',
        gap: '24px',
        maxWidth: '700px',
        margin: '0 auto',
      }}>
        <div style={{
          background: '#f9fafb',
          borderRadius: '16px',
          padding: '24px',
          border: '2px solid #e5e7eb',
        }}>
          <h4 style={{ color: '#374151', marginBottom: '16px', fontSize: '1.1rem' }}>
            📦 {slide.content.regular.title}
          </h4>
          {slide.content.regular.points.map((p, i) => (
            <div key={i} style={{
              padding: '10px 14px',
              background: '#e5e7eb',
              borderRadius: '8px',
              marginBottom: '8px',
              color: '#4b5563',
              fontSize: '0.9rem',
            }}>
              {p}
            </div>
          ))}
        </div>
        
        <div style={{
          background: 'linear-gradient(135deg, #dbeafe, #ede9fe)',
          borderRadius: '16px',
          padding: '24px',
          border: '2px solid #6366f1',
        }}>
          <h4 style={{ color: '#4338ca', marginBottom: '16px', fontSize: '1.1rem' }}>
            ⏪ {slide.content.pitr.title}
          </h4>
          {slide.content.pitr.points.map((p, i) => (
            <div key={i} style={{
              padding: '10px 14px',
              background: 'rgba(255,255,255,0.6)',
              borderRadius: '8px',
              marginBottom: '8px',
              color: '#4338ca',
              fontSize: '0.9rem',
              fontWeight: 500,
            }}>
              {p}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function RPOSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '12px',
        maxWidth: '600px',
        margin: '0 auto',
      }}>
        {slide.content.levels.map((level, i) => (
          <div key={i} style={{
            display: 'grid',
            gridTemplateColumns: '100px 1fr 80px',
            alignItems: 'center',
            gap: '16px',
            padding: '16px 20px',
            background: i === 2 ? 'linear-gradient(90deg, #dbeafe, #ede9fe)' : '#f9fafb',
            borderRadius: '12px',
            border: i === 2 ? '2px solid #6366f1' : '1px solid #e5e7eb',
          }}>
            <div style={{
              fontWeight: 700,
              color: i === 2 ? '#4338ca' : '#374151',
              fontSize: '1rem',
            }}>
              {level.rpo}
            </div>
            <div style={{
              color: '#6b7280',
              fontSize: '0.9rem',
            }}>
              {level.method}
            </div>
            <div style={{
              textAlign: 'right',
              color: '#22c55e',
              fontWeight: 600,
            }}>
              {level.cost}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function RequirementsSlide({ slide }) {
  const [checked, setChecked] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setChecked(c => c < slide.content.items.length ? c + 1 : c);
    }, 500);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '12px',
        maxWidth: '400px',
        margin: '0 auto',
      }}>
        {slide.content.items.map((item, i) => (
          <div key={i} style={{
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
            padding: '16px 20px',
            background: i < checked ? '#f0fdf4' : '#f9fafb',
            border: i < checked ? '2px solid #22c55e' : '2px solid #e5e7eb',
            borderRadius: '12px',
            opacity: i < checked ? 1 : 0.5,
            transition: 'all 0.3s ease',
          }}>
            <div style={{
              width: '28px',
              height: '28px',
              borderRadius: '50%',
              background: i < checked ? '#22c55e' : '#e5e7eb',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
              fontSize: '0.9rem',
            }}>
              ✓
            </div>
            <span style={{ color: '#374151', fontWeight: 500 }}>{item.text}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function StorageSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        maxWidth: '500px',
        margin: '0 auto',
      }}>
        <div style={{
          background: '#fffbeb',
          border: '2px solid #f59e0b',
          borderRadius: '16px',
          padding: '24px',
          marginBottom: '20px',
        }}>
          <div style={{ fontWeight: 600, color: '#92400e', marginBottom: '16px' }}>Example Calculation:</div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {Object.entries(slide.content.example).map(([key, val]) => (
              <div key={key} style={{
                display: 'flex',
                justifyContent: 'space-between',
                padding: '8px 12px',
                background: 'rgba(255,255,255,0.6)',
                borderRadius: '6px',
              }}>
                <span style={{ color: '#6b7280', fontSize: '0.9rem' }}>{key}:</span>
                <span style={{ color: '#92400e', fontWeight: 600, fontSize: '0.9rem' }}>{val}</span>
              </div>
            ))}
          </div>
        </div>
        
        <div style={{
          background: '#f0fdf4',
          border: '1px solid #22c55e',
          borderRadius: '12px',
          padding: '16px 20px',
          textAlign: 'center',
        }}>
          <span style={{ color: '#166534', fontWeight: 500 }}>
            💡 {slide.content.tip}
          </span>
        </div>
      </div>
    </div>
  );
}

function RealWorldSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        gap: '16px',
        maxWidth: '600px',
        margin: '0 auto',
      }}>
        {slide.content.databases.map((db, i) => (
          <div key={i} style={{
            padding: '20px',
            background: '#f9fafb',
            borderRadius: '12px',
            border: '1px solid #e5e7eb',
            textAlign: 'center',
          }}>
            <div style={{
              fontWeight: 700,
              color: '#1a1a2e',
              marginBottom: '8px',
              fontSize: '1.1rem',
            }}>
              {db.name}
            </div>
            <code style={{
              fontSize: '0.8rem',
              color: '#6b7280',
              background: '#e5e7eb',
              padding: '4px 10px',
              borderRadius: '6px',
            }}>
              {db.cmd}
            </code>
          </div>
        ))}
      </div>
    </div>
  );
}

function BestPracticesSlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        gap: '12px',
        maxWidth: '600px',
        margin: '0 auto',
      }}>
        {slide.content.practices.map((p, i) => (
          <div key={i} style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            padding: '14px 18px',
            background: 'linear-gradient(135deg, #f0fdf4, #f0f9ff)',
            borderRadius: '10px',
            border: '1px solid #bbf7d0',
          }}>
            <span style={{
              width: '24px',
              height: '24px',
              borderRadius: '50%',
              background: '#22c55e',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '0.75rem',
              fontWeight: 700,
            }}>
              {i + 1}
            </span>
            <span style={{ color: '#166534', fontWeight: 500, fontSize: '0.9rem' }}>{p}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function SummarySlide({ slide }) {
  return (
    <div style={{ padding: '40px' }}>
      <h2 style={{ fontSize: '2rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>{slide.title}</h2>
      <p style={{ color: '#6b7280', marginBottom: '40px', textAlign: 'center' }}>{slide.subtitle}</p>
      
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '14px',
        maxWidth: '500px',
        margin: '0 auto',
      }}>
        {slide.content.points.map((point, i) => (
          <div key={i} style={{
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
            padding: '18px 22px',
            background: 'linear-gradient(135deg, #eff6ff, #faf5ff)',
            borderRadius: '12px',
            border: '1px solid #c7d2fe',
          }}>
            <span style={{
              width: '36px',
              height: '36px',
              borderRadius: '50%',
              background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 800,
            }}>
              {i + 1}
            </span>
            <span style={{ color: '#1e3a5f', fontWeight: 600, fontSize: '1rem' }}>{point}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function DemoSlide() {
  const [baseBackup, setBaseBackup] = useState(null);
  const [walLogs, setWalLogs] = useState([]);
  const [db, setDb] = useState([]);
  const [crashed, setCrashed] = useState(false);
  const [recovering, setRecovering] = useState(false);
  const [targetTime, setTargetTime] = useState(null);

  const queries = [
    { op: 'INSERT', data: "user: Alice" },
    { op: 'UPDATE', data: "balance: 500" },
    { op: 'INSERT', data: "order: #101" },
    { op: 'DELETE', data: "session: old" },
  ];

  const takeBackup = () => {
    setBaseBackup({ time: new Date().toLocaleTimeString(), data: [...db] });
  };

  const runQuery = () => {
    if (crashed) return;
    const q = queries[walLogs.length % queries.length];
    const time = new Date().toLocaleTimeString();
    const entry = { ...q, time, lsn: walLogs.length + 1 };
    setWalLogs(prev => [...prev, entry]);
    setDb(prev => [...prev, entry]);
  };

  const simulateDisaster = () => {
    if (db.length === 0) return;
    setCrashed(true);
    setDb([]);
  };

  const recoverTo = (targetLsn) => {
    if (!baseBackup) return;
    setRecovering(true);
    setTargetTime(walLogs[targetLsn - 1]?.time);
    
    setTimeout(() => {
      setDb(baseBackup.data);
      
      let i = 0;
      const replay = () => {
        if (i < targetLsn) {
          setDb(prev => [...prev, walLogs[i]]);
          i++;
          setTimeout(replay, 400);
        } else {
          setRecovering(false);
          setCrashed(false);
        }
      };
      setTimeout(replay, 500);
    }, 500);
  };

  const reset = () => {
    setBaseBackup(null);
    setWalLogs([]);
    setDb([]);
    setCrashed(false);
    setRecovering(false);
    setTargetTime(null);
  };

  return (
    <div style={{ padding: '30px' }}>
      <h2 style={{ fontSize: '1.8rem', color: '#1a1a2e', marginBottom: '8px', textAlign: 'center' }}>Live Demo</h2>
      <p style={{ color: '#6b7280', marginBottom: '24px', textAlign: 'center' }}>
        {crashed ? '💥 DATABASE CRASHED' : recovering ? '🔄 RECOVERING...' : '✅ Running'}
        {targetTime && ` to ${targetTime}`}
      </p>
      
      <div style={{
        display: 'grid',
        gridTemplateColumns: '1fr 1fr 1fr',
        gap: '16px',
        marginBottom: '20px',
      }}>
        {/* Base Backup */}
        <div style={{
          background: baseBackup ? '#dbeafe' : '#f9fafb',
          borderRadius: '12px',
          padding: '14px',
          border: `2px solid ${baseBackup ? '#3b82f6' : '#e5e7eb'}`,
          minHeight: '180px',
        }}>
          <h4 style={{ color: baseBackup ? '#1d4ed8' : '#9ca3af', marginBottom: '10px', fontSize: '0.9rem' }}>
            📦 Base Backup
          </h4>
          {baseBackup ? (
            <div>
              <div style={{ fontSize: '0.75rem', color: '#6b7280', marginBottom: '8px' }}>
                Taken: {baseBackup.time}
              </div>
              <div style={{ fontSize: '0.8rem', color: '#1d4ed8' }}>
                {baseBackup.data.length} records
              </div>
            </div>
          ) : (
            <div style={{ color: '#9ca3af', fontSize: '0.85rem' }}>No backup yet</div>
          )}
        </div>
        
        {/* WAL Archive */}
        <div style={{
          background: '#fef3c7',
          borderRadius: '12px',
          padding: '14px',
          border: '2px solid #f59e0b',
          minHeight: '180px',
          overflow: 'auto',
        }}>
          <h4 style={{ color: '#92400e', marginBottom: '10px', fontSize: '0.9rem' }}>📝 WAL Archive</h4>
          {walLogs.length === 0 ? (
            <div style={{ color: '#9ca3af', fontSize: '0.85rem' }}>Empty</div>
          ) : (
            walLogs.map((log, i) => (
              <div key={i} style={{
                display: 'flex',
                justifyContent: 'space-between',
                padding: '4px 8px',
                background: 'rgba(255,255,255,0.5)',
                borderRadius: '4px',
                marginBottom: '4px',
                fontSize: '0.75rem',
              }}>
                <span style={{ color: '#92400e' }}>#{log.lsn}</span>
                <span style={{ color: '#6b7280' }}>{log.time}</span>
              </div>
            ))
          )}
        </div>
        
        {/* Database */}
        <div style={{
          background: crashed ? '#fee2e2' : '#f0fdf4',
          borderRadius: '12px',
          padding: '14px',
          border: `2px solid ${crashed ? '#ef4444' : '#22c55e'}`,
          minHeight: '180px',
          overflow: 'auto',
        }}>
          <h4 style={{ color: crashed ? '#991b1b' : '#166534', marginBottom: '10px', fontSize: '0.9rem' }}>
            🗄️ Database
          </h4>
          {db.length === 0 ? (
            <div style={{ color: crashed ? '#991b1b' : '#9ca3af', fontSize: '0.85rem' }}>
              {crashed ? 'DATA LOST!' : 'Empty'}
            </div>
          ) : (
            db.map((row, i) => (
              <div key={i} style={{
                padding: '4px 8px',
                background: 'rgba(255,255,255,0.6)',
                borderRadius: '4px',
                marginBottom: '4px',
                fontSize: '0.75rem',
                color: '#166534',
              }}>
                {row.op}: {row.data}
              </div>
            ))
          )}
        </div>
      </div>
      
      {/* Controls */}
      <div style={{ display: 'flex', justifyContent: 'center', gap: '10px', flexWrap: 'wrap', marginBottom: '16px' }}>
        <button onClick={takeBackup} disabled={crashed || recovering} style={{
          padding: '10px 20px',
          background: !crashed && !recovering ? '#3b82f6' : '#9ca3af',
          color: '#fff',
          border: 'none',
          borderRadius: '8px',
          fontWeight: 600,
          cursor: !crashed && !recovering ? 'pointer' : 'not-allowed',
          fontSize: '0.85rem',
        }}>
          📦 Take Backup
        </button>
        <button onClick={runQuery} disabled={crashed || recovering} style={{
          padding: '10px 20px',
          background: !crashed && !recovering ? '#22c55e' : '#9ca3af',
          color: '#fff',
          border: 'none',
          borderRadius: '8px',
          fontWeight: 600,
          cursor: !crashed && !recovering ? 'pointer' : 'not-allowed',
          fontSize: '0.85rem',
        }}>
          ⚡ Run Query
        </button>
        <button onClick={simulateDisaster} disabled={crashed || recovering || db.length === 0} style={{
          padding: '10px 20px',
          background: !crashed && !recovering && db.length > 0 ? '#ef4444' : '#9ca3af',
          color: '#fff',
          border: 'none',
          borderRadius: '8px',
          fontWeight: 600,
          cursor: !crashed && !recovering && db.length > 0 ? 'pointer' : 'not-allowed',
          fontSize: '0.85rem',
        }}>
          💥 Crash!
        </button>
        <button onClick={reset} style={{
          padding: '10px 20px',
          background: '#6b7280',
          color: '#fff',
          border: 'none',
          borderRadius: '8px',
          fontWeight: 600,
          cursor: 'pointer',
          fontSize: '0.85rem',
        }}>
          ↺ Reset
        </button>
      </div>
      
      {/* PITR Recovery */}
      {crashed && baseBackup && walLogs.length > 0 && (
        <div style={{
          background: '#faf5ff',
          border: '2px solid #8b5cf6',
          borderRadius: '12px',
          padding: '16px',
          textAlign: 'center',
        }}>
          <div style={{ color: '#6d28d9', fontWeight: 600, marginBottom: '12px' }}>
            ⏪ Point-in-Time Recovery - Select target:
          </div>
          <div style={{ display: 'flex', justifyContent: 'center', gap: '8px', flexWrap: 'wrap' }}>
            {walLogs.map((log, i) => (
              <button key={i} onClick={() => recoverTo(i + 1)} disabled={recovering} style={{
                padding: '8px 16px',
                background: '#8b5cf6',
                color: '#fff',
                border: 'none',
                borderRadius: '6px',
                cursor: recovering ? 'not-allowed' : 'pointer',
                fontSize: '0.8rem',
              }}>
                {log.time}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

function renderSlide(slide) {
  switch (slide.type) {
    case 'title': return <TitleSlide slide={slide} />;
    case 'scenario': return <ScenarioSlide slide={slide} />;
    case 'backup-problem': return <BackupProblemSlide slide={slide} />;
    case 'solution': return <SolutionSlide slide={slide} />;
    case 'components': return <ComponentsSlide slide={slide} />;
    case 'base-backup': return <BaseBackupSlide slide={slide} />;
    case 'wal-archive': return <WALArchiveSlide slide={slide} />;
    case 'timeline': return <TimelineSlide slide={slide} />;
    case 'recovery-steps': return <RecoveryStepsSlide slide={slide} />;
    case 'replay-animation': return <ReplayAnimationSlide />;
    case 'target-options': return <TargetOptionsSlide slide={slide} />;
    case 'use-cases': return <UseCasesSlide slide={slide} />;
    case 'comparison': return <ComparisonSlide slide={slide} />;
    case 'rpo': return <RPOSlide slide={slide} />;
    case 'requirements': return <RequirementsSlide slide={slide} />;
    case 'storage': return <StorageSlide slide={slide} />;
    case 'real-world': return <RealWorldSlide slide={slide} />;
    case 'best-practices': return <BestPracticesSlide slide={slide} />;
    case 'summary': return <SummarySlide slide={slide} />;
    case 'demo': return <DemoSlide />;
    default: return null;
  }
}

export default function PITRSlideshow() {
  const [current, setCurrent] = useState(0);

  const next = () => setCurrent(c => Math.min(c + 1, slides.length - 1));
  const prev = () => setCurrent(c => Math.max(c - 1, 0));

  useEffect(() => {
    const handleKey = (e) => {
      if (e.key === 'ArrowRight' || e.key === ' ') next();
      if (e.key === 'ArrowLeft') prev();
    };
    window.addEventListener('keydown', handleKey);
    return () => window.removeEventListener('keydown', handleKey);
  }, []);

  return (
    <div style={{
      minHeight: '100vh',
      background: '#ffffff',
      fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, sans-serif",
      display: 'flex',
      flexDirection: 'column',
    }}>
      {/* Slide content */}
      <div style={{
        flex: 1,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '20px',
      }}>
        <div style={{
          width: '100%',
          maxWidth: '900px',
          animation: 'slideIn 0.4s ease',
        }} key={current}>
          {renderSlide(slides[current])}
        </div>
      </div>
      
      {/* Navigation */}
      <div style={{
        padding: '20px 40px',
        borderTop: '1px solid #e5e7eb',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        background: '#fafafa',
      }}>
        <button
          onClick={prev}
          disabled={current === 0}
          style={{
            padding: '12px 24px',
            background: current === 0 ? '#f3f4f6' : '#1a1a2e',
            color: current === 0 ? '#9ca3af' : '#fff',
            border: 'none',
            borderRadius: '8px',
            fontWeight: 600,
            cursor: current === 0 ? 'not-allowed' : 'pointer',
          }}
        >
          ← Previous
        </button>
        
        <div style={{
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
        }}>
          {slides.map((_, i) => (
            <button
              key={i}
              onClick={() => setCurrent(i)}
              style={{
                width: i === current ? '20px' : '8px',
                height: '8px',
                borderRadius: '4px',
                background: i === current ? '#8b5cf6' : '#d1d5db',
                border: 'none',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
              }}
            />
          ))}
        </div>
        
        <button
          onClick={next}
          disabled={current === slides.length - 1}
          style={{
            padding: '12px 24px',
            background: current === slides.length - 1 ? '#f3f4f6' : '#8b5cf6',
            color: current === slides.length - 1 ? '#9ca3af' : '#fff',
            border: 'none',
            borderRadius: '8px',
            fontWeight: 600,
            cursor: current === slides.length - 1 ? 'not-allowed' : 'pointer',
          }}
        >
          Next →
        </button>
      </div>
      
      {/* Slide counter */}
      <div style={{
        position: 'fixed',
        bottom: '80px',
        right: '40px',
        padding: '8px 16px',
        background: '#1a1a2e',
        color: '#fff',
        borderRadius: '20px',
        fontSize: '0.85rem',
        fontWeight: 600,
      }}>
        {current + 1} / {slides.length}
      </div>
      
      <style>{`
        @keyframes slideIn {
          from { opacity: 0; transform: translateX(20px); }
          to { opacity: 1; transform: translateX(0); }
        }
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(10px); }
          to { opacity: 1; transform: translateY(0); }
        }
        @keyframes shake {
          0%, 100% { transform: translateX(0); }
          20% { transform: translateX(-10px); }
          40% { transform: translateX(10px); }
          60% { transform: translateX(-10px); }
          80% { transform: translateX(10px); }
        }
      `}</style>
    </div>
  );
}
