#!/usr/bin/env bash
set -Eeuo pipefail

file="$(readlink -f "${1:-prof.bin}")"
iface="${2:-eth0}"

export S_TIME_FORMAT=ISO
sar -f "$file" -r | sed '1,2d;$d' >/tmp/mem.dat
sar -f "$file" -u | sed '1,2d;$d' >/tmp/cpu.dat
sar -f "$file" -n DEV --iface="$iface" | sed '1,2d;$d' >/tmp/dev.dat
sar -f "$file" -n SOCK | sed '1,2d;$d' >/tmp/sock.dat

cat <<EOF | gnuplot >"stats.png"
set terminal pngcairo dashed size 1600,900 background rgb "#0d1117"
set label font "Arial,12" textcolor rgb "#f0f6fc"
set xtics textcolor rgb "#f0f6fc"
set ytics textcolor rgb "#f0f6fc"
set style line 10 linecolor rgb "#a3a3a3" dashtype 3
set style line 1 lt 1 lc rgb "#4493f8"
set style line 2 lt 1 lc rgb "#3fb950"

set grid linestyle 10
set style data lines

set key autotitle columnhead outside textcolor rgb "#f0f6fc"

set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
set yrange [0:*]
set autoscale

set multiplot layout 4,1 title "System Statistics" textcolor rgb "#f0f6fc" font "Arial,16"

set title "CPU" textcolor rgb "#f0f6fc"
plot "/tmp/cpu.dat" using 1:(100 - column(8)) ls 1 smooth freq title "CPU Busy (%)"

set title "Memory" textcolor rgb "#f0f6fc"
plot "/tmp/mem.dat" using 1:(column(4) / 1048576) ls 1 smooth freq title "Memory Used (GB)"

set title "Net I/O" textcolor rgb "#f0f6fc"
plot "/tmp/dev.dat" using 1:(column(5) * 8 / 1000) ls 1 smooth freq title "TX (mB/s)", \
     "/tmp/dev.dat" using 1:(column(6) * 8 / 1000) ls 2 smooth freq title "RX (mB/s)"

set title "Sockets" textcolor rgb "#f0f6fc"
plot "/tmp/sock.dat" using 1:2 ls 1 smooth freq title "Open Sockets"
EOF
