{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf610
{\fonttbl\f0\fswiss\fcharset0 ArialMT;}
{\colortbl;\red255\green255\blue255;\red26\green26\blue26;\red255\green255\blue255;}
{\*\expandedcolortbl;;\cssrgb\c13333\c13333\c13333;\cssrgb\c100000\c100000\c100000;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl300\partightenfactor0

\f0\fs26\fsmilli13333 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 select to_char(round(sample_time, 'MI'), 'YYYY-MM-DD HH24:MI') as sample_minute,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0 session_state,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0 avg(a.active_sessions)\'a0AAS
\fs20 \

\fs26\fsmilli13333 from
\fs20 \

\fs26\fsmilli13333 (
\fs20 \

\fs26\fsmilli13333 select
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 sample_id,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 sample_time,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 session_state,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 count(*) as active_sessions
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0 from
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 v$active_session_history
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0 where
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 sample_time > sysdate - (:minutes/1440)
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0 group by
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 sample_id,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0 sample_time,
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0\'a0session_state
\fs20 \

\fs26\fsmilli13333 ) a
\fs20 \

\fs26\fsmilli13333 group by to_char(round(sample_time, 'MI'), 'YYYY-MM-DD HH24:MI'),
\fs20 \

\fs26\fsmilli13333 \'a0\'a0\'a0\'a0\'a0\'a0 session_state
\fs20 \

\fs26\fsmilli13333 order by 1,2
\fs20 \
}