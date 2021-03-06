/*
 *  GRUB  --  GRand Unified Bootloader
 *  Copyright (C) 2010  Free Software Foundation, Inc.
 *
 *  GRUB is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  GRUB is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GRUB.  If not, see <http://www.gnu.org/licenses/>.
 */

#define SYSCALL_WRITE 1
#define SYSCALL_RESET 169
#define SYSCALL_IOPL 172
#define SYSCALL_EXIT 60

#define STDOUT 1
#define SHUTDOWN_MAGIC1 0xfee1dead
#define SHUTDOWN_MAGIC2 0x28121969
#define SHUTDOWN_MAGIC3 0x4321fedc

	.text
	.global start, _start
_start:
start:
	/* write.  */
	movq $SYSCALL_WRITE, %rax
	movq $STDOUT, %rdi
	leaq message, %rsi
	movq $(messageend-message), %rdx
	syscall

	movq $SYSCALL_IOPL, %rax
	movq $3, %rdi
	syscall

#include "qemu-shutdown-x86.S"
	
	/* shutdown.  */
	movq $SYSCALL_RESET, %rax
	movq $SHUTDOWN_MAGIC1, %rdi
	movq $SHUTDOWN_MAGIC2, %rsi
	movq $SHUTDOWN_MAGIC3, %rdx
	syscall

	/* exit(1). Shouldn't be reached.  */
	movq $SYSCALL_EXIT, %rax
	movq $1, %rdi
	syscall
	.data
message:
	.ascii "Boot Test Passed Successfully\n" SUCCESSFUL_BOOT_STRING "\n"
messageend:
