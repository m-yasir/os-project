
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 95 42 00 00       	call   801042f0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 23 41 00 00       	call   801041c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 47 43 00 00       	call   80104430 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 89 43 00 00       	call   801044f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 40 00 00       	call   80104200 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 6f 10 80       	push   $0x80106fce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 40 00 00       	call   801042a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 6f 10 80       	push   $0x80106fdf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 40 00 00       	call   801042a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 40 00 00       	call   80104260 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 20 42 00 00       	call   80104430 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 42 00 00       	jmp    801044f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 6f 10 80       	push   $0x80106fe6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 9f 41 00 00       	call   80104430 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 d6 3a 00 00       	call   80103da0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 00 35 00 00       	call   801037e0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 fc 41 00 00       	call   801044f0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 9e 41 00 00       	call   801044f0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 6f 10 80       	push   $0x80106fed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 29 76 10 80 	movl   $0x80107629,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 3f 00 00       	call   80104310 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 70 10 80       	push   $0x80107001
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 57 00 00       	call   80105bc0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 56 00 00       	call   80105bc0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 56 00 00       	call   80105bc0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 56 00 00       	call   80105bc0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 c7 40 00 00       	call   801045f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 fa 3f 00 00       	call   80104540 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 70 10 80       	push   $0x80107005
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 10 3e 00 00       	call   80104430 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 a4 3e 00 00       	call   801044f0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 cc 3d 00 00       	call   801044f0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 70 10 80       	mov    $0x80107018,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 3b 3c 00 00       	call   80104430 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 70 10 80       	push   $0x8010701f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 08 3c 00 00       	call   80104430 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 63 3c 00 00       	call   801044f0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 35 36 00 00       	call   80103f50 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 94 36 00 00       	jmp    80104030 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 70 10 80       	push   $0x80107028
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 1b 39 00 00       	call   801042f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 bf 2d 00 00       	call   801037e0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 77 62 00 00       	call   80106d10 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 93 02 00 00    	je     80100d52 <exec+0x342>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 35 60 00 00       	call   80106b30 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 43 5f 00 00       	call   80106a70 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 19 61 00 00       	call   80106c90 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 81 5f 00 00       	call   80106b30 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ca 60 00 00       	call   80106c90 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 70 10 80       	push   $0x80107041
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 a5 61 00 00       	call   80106db0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 22 3b 00 00       	call   80104760 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 0f 3b 00 00       	call   80104760 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ae 62 00 00       	call   80106f10 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 44 62 00 00       	call   80106f10 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 11 3a 00 00       	call   80104720 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority = 3;
80100d31:	c7 41 7c 03 00 00 00 	movl   $0x3,0x7c(%ecx)
  switchuvm(curproc);
80100d38:	89 0c 24             	mov    %ecx,(%esp)
80100d3b:	e8 a0 5b 00 00       	call   801068e0 <switchuvm>
  freevm(oldpgdir);
80100d40:	89 3c 24             	mov    %edi,(%esp)
80100d43:	e8 48 5f 00 00       	call   80106c90 <freevm>
  return 0;
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	31 c0                	xor    %eax,%eax
80100d4d:	e9 2a fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d52:	be 00 20 00 00       	mov    $0x2000,%esi
80100d57:	e9 35 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d5c:	66 90                	xchg   %ax,%ax
80100d5e:	66 90                	xchg   %ax,%ax

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 70 10 80       	push   $0x8010704d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 7b 35 00 00       	call   801042f0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 9a 36 00 00       	call   80104430 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 2a 37 00 00       	call   801044f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 11 37 00 00       	call   801044f0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 2c 36 00 00       	call   80104430 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 cf 36 00 00       	call   801044f0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 70 10 80       	push   $0x80107054
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 da 35 00 00       	call   80104430 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 6f 36 00 00       	jmp    801044f0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 43 36 00 00       	call   801044f0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 70 10 80       	push   $0x8010705c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 70 10 80       	push   $0x80107066
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 70 10 80       	push   $0x8010706f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 70 10 80       	push   $0x80107075
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 7f 70 10 80       	push   $0x8010707f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 92 70 10 80       	push   $0x80107092
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 d6 32 00 00       	call   80104540 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 81 31 00 00       	call   80104430 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 e0 09 11 80       	push   $0x801109e0
8010130f:	e8 dc 31 00 00       	call   801044f0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 ae 31 00 00       	call   801044f0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 a8 70 10 80       	push   $0x801070a8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 b8 70 10 80       	push   $0x801070b8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 8a 31 00 00       	call   801045f0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 cb 70 10 80       	push   $0x801070cb
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 55 2e 00 00       	call   801042f0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 70 10 80       	push   $0x801070d2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 0c 2d 00 00       	call   801041c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 c0 09 11 80       	push   $0x801109c0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014d5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014db:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014e1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014e7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ed:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014f3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014f9:	68 38 71 10 80       	push   $0x80107138
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 ad 2f 00 00       	call   80104540 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 d8 70 10 80       	push   $0x801070d8
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 ba 2f 00 00       	call   801045f0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 e0 09 11 80       	push   $0x801109e0
8010165f:	e8 cc 2d 00 00       	call   80104430 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 7c 2e 00 00       	call   801044f0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 59 2b 00 00       	call   80104200 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 d3 2e 00 00       	call   801045f0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 f0 70 10 80       	push   $0x801070f0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 70 10 80       	push   $0x801070ea
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 28 2b 00 00       	call   801042a0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 cc 2a 00 00       	jmp    80104260 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 70 10 80       	push   $0x801070ff
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 3b 2a 00 00       	call   80104200 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 81 2a 00 00       	call   80104260 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 45 2c 00 00       	call   80104430 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 eb 2c 00 00       	jmp    801044f0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 1b 2c 00 00       	call   80104430 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 cc 2c 00 00       	call   801044f0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 e4 2b 00 00       	call   801045f0 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 e8 2a 00 00       	call   801045f0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 bd 2a 00 00       	call   80104660 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 5e 2a 00 00       	call   80104660 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 19 71 10 80       	push   $0x80107119
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 71 10 80       	push   $0x80107107
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 62 1b 00 00       	call   801037e0 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 e0 09 11 80       	push   $0x801109e0
80101c89:	e8 a2 27 00 00       	call   80104430 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c99:	e8 52 28 00 00       	call   801044f0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 f6 28 00 00       	call   801045f0 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 63 28 00 00       	call   801045f0 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 3e 28 00 00       	call   801046c0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 28 71 10 80       	push   $0x80107128
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 82 77 10 80       	push   $0x80107782
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 94 71 10 80       	push   $0x80107194
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 8b 71 10 80       	push   $0x8010718b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 a6 71 10 80       	push   $0x801071a6
8010200b:	68 80 a5 10 80       	push   $0x8010a580
80102010:	e8 db 22 00 00       	call   801042f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 e0 28 11 80       	mov    0x801128e0,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 a5 10 80       	push   $0x8010a580
8010208e:	e8 9d 23 00 00       	call   80104430 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 5a 1e 00 00       	call   80103f50 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 a5 10 80       	push   $0x8010a580
8010210f:	e8 dc 23 00 00       	call   801044f0 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 6d 21 00 00       	call   801042a0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 a5 10 80       	push   $0x8010a580
80102168:	e8 c3 22 00 00       	call   80104430 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 a5 10 80       	push   $0x8010a580
801021b8:	53                   	push   %ebx
801021b9:	e8 e2 1b 00 00       	call   80103da0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 15 23 00 00       	jmp    801044f0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 c0 71 10 80       	push   $0x801071c0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 aa 71 10 80       	push   $0x801071aa
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 d5 71 10 80       	push   $0x801071d5
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 34 26 11 80       	mov    0x80112634,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 f4 71 10 80       	push   $0x801071f4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb 88 51 11 80    	cmp    $0x80115188,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 f9 21 00 00       	call   80104540 <memset>

  if(kmem.use_lock)
80102347:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 78 26 11 80       	mov    0x80112678,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102360:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 70 21 00 00       	jmp    801044f0 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 40 26 11 80       	push   $0x80112640
80102388:	e8 a3 20 00 00       	call   80104430 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 26 72 10 80       	push   $0x80107226
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 2c 72 10 80       	push   $0x8010722c
80102400:	68 40 26 11 80       	push   $0x80112640
80102405:	e8 e6 1e 00 00       	call   801042f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 74 26 11 80       	mov    0x80112674,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 40 26 11 80       	push   $0x80112640
801024f3:	e8 38 1f 00 00       	call   80104430 <acquire>
  r = kmem.freelist;
801024f8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 40 26 11 80       	push   $0x80112640
80102521:	e8 ca 1f 00 00       	call   801044f0 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 60 72 10 80 	movzbl -0x7fef8da0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 54 1c 00 00       	call   80104590 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a44:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 87 1b 00 00       	call   801045f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102aae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 60 74 10 80       	push   $0x80107460
80102b0f:	68 80 26 11 80       	push   $0x80112680
80102b14:	e8 d7 17 00 00       	call   801042f0 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b32:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b38:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 80 26 11 80       	push   $0x80112680
80102bab:	e8 80 18 00 00       	call   80104430 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 80 26 11 80       	push   $0x80112680
80102bc0:	68 80 26 11 80       	push   $0x80112680
80102bc5:	e8 d6 11 00 00       	call   80103da0 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102bdb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102bf7:	68 80 26 11 80       	push   $0x80112680
80102bfc:	e8 ef 18 00 00       	call   801044f0 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 80 26 11 80       	push   $0x80112680
80102c1e:	e8 0d 18 00 00       	call   80104430 <acquire>
  log.outstanding -= 1;
80102c23:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c28:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 80 26 11 80       	push   $0x80112680
80102c5c:	e8 8f 18 00 00       	call   801044f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c96:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 35 19 00 00       	call   801045f0 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 80 26 11 80       	push   $0x80112680
80102cff:	e8 2c 17 00 00       	call   80104430 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d0b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 36 12 00 00       	call   80103f50 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d21:	e8 ca 17 00 00       	call   801044f0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 80 26 11 80       	push   $0x80112680
80102d40:	e8 0b 12 00 00       	call   80103f50 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d4c:	e8 9f 17 00 00       	call   801044f0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 64 74 10 80       	push   $0x80107464
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 80 26 11 80       	push   $0x80112680
80102dae:	e8 7d 16 00 00       	call   80104430 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 ee 16 00 00       	jmp    801044f0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 73 74 10 80       	push   $0x80107473
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 89 74 10 80       	push   $0x80107489
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 74 09 00 00       	call   801037c0 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 6d 09 00 00       	call   801037c0 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 a4 74 10 80       	push   $0x801074a4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 69 29 00 00       	call   801057d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 e4 08 00 00       	call   80103750 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 21 0c 00 00       	call   80103aa0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 35 3a 00 00       	call   801068c0 <switchkvm>
  seginit();
80102e8b:	e8 a0 39 00 00       	call   80106830 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 88 51 11 80       	push   $0x80115188
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 ca 3e 00 00       	call   80106d90 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 5b 39 00 00       	call   80106830 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 17 2c 00 00       	call   80105b00 <uartinit>
  pinit();         // process table
80102ee9:	e8 42 08 00 00       	call   80103730 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 5d 28 00 00       	call   80105750 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 8c a4 10 80       	push   $0x8010a48c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 d7 16 00 00       	call   801045f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 e0 28 11 80 b0 	imul   $0xb0,0x801128e0,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 80 27 11 80       	add    $0x80112780,%eax
80102f2b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 0b 08 00 00       	call   80103750 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f64:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 e0 28 11 80 b0 	imul   $0xb0,0x801128e0,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 56 08 00 00       	call   80103810 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 b8 74 10 80       	push   $0x801074b8
80102ff3:	56                   	push   %esi
80102ff4:	e8 97 15 00 00       	call   80104590 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 d5 74 10 80       	push   $0x801074d5
801030b1:	56                   	push   %esi
801030b2:	e8 d9 14 00 00       	call   80104590 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 fc 74 10 80 	jmp    *-0x7fef8b04(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d e0 28 11 80    	mov    0x801128e0,%ecx
8010318e:	83 f9 01             	cmp    $0x1,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d e0 28 11 80    	mov    %ecx,0x801128e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 bd 74 10 80       	push   $0x801074bd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 dc 74 10 80       	push   $0x801074dc
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 10 75 10 80       	push   $0x80107510
80103300:	50                   	push   %eax
80103301:	e8 ea 0f 00 00       	call   801042f0 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 cc 10 00 00       	call   80104430 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 cc 0b 00 00       	call   80103f50 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 47 11 00 00       	jmp    801044f0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 87 0b 00 00       	call   80103f50 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 17 11 00 00       	call   801044f0 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 2e 10 00 00       	call   80104430 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 f7 0a 00 00       	call   80103f50 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 3e 09 00 00       	call   80103da0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 57 03 00 00       	call   801037e0 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 57 10 00 00       	call   801044f0 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 68 0a 00 00       	call   80103f50 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 00 10 00 00       	call   801044f0 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 1b 0f 00 00       	call   80104430 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 56 08 00 00       	call   80103da0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 72 02 00 00       	call   801037e0 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 6d 0f 00 00       	call   801044f0 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 74 09 00 00       	call   80103f50 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 0c 0f 00 00       	call   801044f0 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103604:	bb 34 29 11 80       	mov    $0x80112934,%ebx
{
80103609:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010360c:	68 00 29 11 80       	push   $0x80112900
80103611:	e8 1a 0e 00 00       	call   80104430 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 14                	jmp    8010362f <allocproc+0x2f>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	83 eb 80             	sub    $0xffffff80,%ebx
80103623:	81 fb 34 49 11 80    	cmp    $0x80114934,%ebx
80103629:	0f 83 81 00 00 00    	jae    801036b0 <allocproc+0xb0>
    if(p->state == UNUSED)
8010362f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103632:	85 c0                	test   %eax,%eax
80103634:	75 ea                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103636:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 10; //default priorty
  release(&ptable.lock);
8010363b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010363e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10; //default priorty
80103645:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->pid = nextpid++;
8010364c:	8d 50 01             	lea    0x1(%eax),%edx
8010364f:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103652:	68 00 29 11 80       	push   $0x80112900
  p->pid = nextpid++;
80103657:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010365d:	e8 8e 0e 00 00       	call   801044f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103662:	e8 59 ee ff ff       	call   801024c0 <kalloc>
80103667:	83 c4 10             	add    $0x10,%esp
8010366a:	85 c0                	test   %eax,%eax
8010366c:	89 43 08             	mov    %eax,0x8(%ebx)
8010366f:	74 58                	je     801036c9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103671:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103677:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010367a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010367f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103682:	c7 40 14 41 57 10 80 	movl   $0x80105741,0x14(%eax)
  p->context = (struct context*)sp;
80103689:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010368c:	6a 14                	push   $0x14
8010368e:	6a 00                	push   $0x0
80103690:	50                   	push   %eax
80103691:	e8 aa 0e 00 00       	call   80104540 <memset>
  p->context->eip = (uint)forkret;
80103696:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103699:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010369c:	c7 40 10 e0 36 10 80 	movl   $0x801036e0,0x10(%eax)
}
801036a3:	89 d8                	mov    %ebx,%eax
801036a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036b5:	68 00 29 11 80       	push   $0x80112900
801036ba:	e8 31 0e 00 00       	call   801044f0 <release>
}
801036bf:	89 d8                	mov    %ebx,%eax
  return 0;
801036c1:	83 c4 10             	add    $0x10,%esp
}
801036c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036c7:	c9                   	leave  
801036c8:	c3                   	ret    
    p->state = UNUSED;
801036c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036d0:	31 db                	xor    %ebx,%ebx
801036d2:	eb cf                	jmp    801036a3 <allocproc+0xa3>
801036d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036e6:	68 00 29 11 80       	push   $0x80112900
801036eb:	e8 00 0e 00 00       	call   801044f0 <release>

  if (first) {
801036f0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	75 04                	jne    80103700 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036fc:	c9                   	leave  
801036fd:	c3                   	ret    
801036fe:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103700:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103703:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010370a:	00 00 00 
    iinit(ROOTDEV);
8010370d:	6a 01                	push   $0x1
8010370f:	e8 6c dd ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103714:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010371b:	e8 e0 f3 ff ff       	call   80102b00 <initlog>
80103720:	83 c4 10             	add    $0x10,%esp
}
80103723:	c9                   	leave  
80103724:	c3                   	ret    
80103725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <pinit>:
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103736:	68 15 75 10 80       	push   $0x80107515
8010373b:	68 00 29 11 80       	push   $0x80112900
80103740:	e8 ab 0b 00 00       	call   801042f0 <initlock>
}
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	c9                   	leave  
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103750 <mycpu>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103756:	9c                   	pushf  
80103757:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103758:	f6 c4 02             	test   $0x2,%ah
8010375b:	75 4a                	jne    801037a7 <mycpu+0x57>
  apicid = lapicid();
8010375d:	e8 ce ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103762:	8b 15 e0 28 11 80    	mov    0x801128e0,%edx
80103768:	85 d2                	test   %edx,%edx
8010376a:	7e 1b                	jle    80103787 <mycpu+0x37>
    if (cpus[i].apicid == apicid)
8010376c:	0f b6 0d 80 27 11 80 	movzbl 0x80112780,%ecx
80103773:	39 c8                	cmp    %ecx,%eax
80103775:	74 21                	je     80103798 <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
80103777:	83 fa 01             	cmp    $0x1,%edx
8010377a:	74 0b                	je     80103787 <mycpu+0x37>
    if (cpus[i].apicid == apicid)
8010377c:	0f b6 15 30 28 11 80 	movzbl 0x80112830,%edx
80103783:	39 d0                	cmp    %edx,%eax
80103785:	74 19                	je     801037a0 <mycpu+0x50>
  panic("unknown apicid\n");
80103787:	83 ec 0c             	sub    $0xc,%esp
8010378a:	68 1c 75 10 80       	push   $0x8010751c
8010378f:	e8 fc cb ff ff       	call   80100390 <panic>
80103794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpus[i].apicid == apicid)
80103798:	b8 80 27 11 80       	mov    $0x80112780,%eax
}
8010379d:	c9                   	leave  
8010379e:	c3                   	ret    
8010379f:	90                   	nop
    if (cpus[i].apicid == apicid)
801037a0:	b8 30 28 11 80       	mov    $0x80112830,%eax
}
801037a5:	c9                   	leave  
801037a6:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
801037a7:	83 ec 0c             	sub    $0xc,%esp
801037aa:	68 58 76 10 80       	push   $0x80107658
801037af:	e8 dc cb ff ff       	call   80100390 <panic>
801037b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037c0 <cpuid>:
cpuid() {
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037c6:	e8 85 ff ff ff       	call   80103750 <mycpu>
801037cb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
801037d0:	c9                   	leave  
  return mycpu()-cpus;
801037d1:	c1 f8 04             	sar    $0x4,%eax
801037d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037da:	c3                   	ret    
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037e0 <myproc>:
myproc(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801037e7:	e8 74 0b 00 00       	call   80104360 <pushcli>
  c = mycpu();
801037ec:	e8 5f ff ff ff       	call   80103750 <mycpu>
  p = c->proc;
801037f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037f7:	e8 a4 0b 00 00       	call   801043a0 <popcli>
}
801037fc:	83 c4 04             	add    $0x4,%esp
801037ff:	89 d8                	mov    %ebx,%eax
80103801:	5b                   	pop    %ebx
80103802:	5d                   	pop    %ebp
80103803:	c3                   	ret    
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <userinit>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103817:	e8 e4 fd ff ff       	call   80103600 <allocproc>
8010381c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010381e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103823:	e8 e8 34 00 00       	call   80106d10 <setupkvm>
80103828:	85 c0                	test   %eax,%eax
8010382a:	89 43 04             	mov    %eax,0x4(%ebx)
8010382d:	0f 84 bd 00 00 00    	je     801038f0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103833:	83 ec 04             	sub    $0x4,%esp
80103836:	68 2c 00 00 00       	push   $0x2c
8010383b:	68 60 a4 10 80       	push   $0x8010a460
80103840:	50                   	push   %eax
80103841:	e8 aa 31 00 00       	call   801069f0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103846:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103849:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010384f:	6a 4c                	push   $0x4c
80103851:	6a 00                	push   $0x0
80103853:	ff 73 18             	pushl  0x18(%ebx)
80103856:	e8 e5 0c 00 00       	call   80104540 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010385b:	8b 43 18             	mov    0x18(%ebx),%eax
8010385e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103863:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103868:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010386b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010386f:	8b 43 18             	mov    0x18(%ebx),%eax
80103872:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103876:	8b 43 18             	mov    0x18(%ebx),%eax
80103879:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010387d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103881:	8b 43 18             	mov    0x18(%ebx),%eax
80103884:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103888:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010388c:	8b 43 18             	mov    0x18(%ebx),%eax
8010388f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038a0:	8b 43 18             	mov    0x18(%ebx),%eax
801038a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038ad:	6a 10                	push   $0x10
801038af:	68 45 75 10 80       	push   $0x80107545
801038b4:	50                   	push   %eax
801038b5:	e8 66 0e 00 00       	call   80104720 <safestrcpy>
  p->cwd = namei("/");
801038ba:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801038c1:	e8 1a e6 ff ff       	call   80101ee0 <namei>
801038c6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801038c9:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
801038d0:	e8 5b 0b 00 00       	call   80104430 <acquire>
  p->state = RUNNABLE;
801038d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801038dc:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
801038e3:	e8 08 0c 00 00       	call   801044f0 <release>
}
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ee:	c9                   	leave  
801038ef:	c3                   	ret    
    panic("userinit: out of memory?");
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	68 2c 75 10 80       	push   $0x8010752c
801038f8:	e8 93 ca ff ff       	call   80100390 <panic>
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <growproc>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
80103905:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103908:	e8 53 0a 00 00       	call   80104360 <pushcli>
  c = mycpu();
8010390d:	e8 3e fe ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103912:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103918:	e8 83 0a 00 00       	call   801043a0 <popcli>
  if(n > 0){
8010391d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103920:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103922:	7f 1c                	jg     80103940 <growproc+0x40>
  } else if(n < 0){
80103924:	75 3a                	jne    80103960 <growproc+0x60>
  switchuvm(curproc);
80103926:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103929:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010392b:	53                   	push   %ebx
8010392c:	e8 af 2f 00 00       	call   801068e0 <switchuvm>
  return 0;
80103931:	83 c4 10             	add    $0x10,%esp
80103934:	31 c0                	xor    %eax,%eax
}
80103936:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103940:	83 ec 04             	sub    $0x4,%esp
80103943:	01 c6                	add    %eax,%esi
80103945:	56                   	push   %esi
80103946:	50                   	push   %eax
80103947:	ff 73 04             	pushl  0x4(%ebx)
8010394a:	e8 e1 31 00 00       	call   80106b30 <allocuvm>
8010394f:	83 c4 10             	add    $0x10,%esp
80103952:	85 c0                	test   %eax,%eax
80103954:	75 d0                	jne    80103926 <growproc+0x26>
      return -1;
80103956:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010395b:	eb d9                	jmp    80103936 <growproc+0x36>
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103960:	83 ec 04             	sub    $0x4,%esp
80103963:	01 c6                	add    %eax,%esi
80103965:	56                   	push   %esi
80103966:	50                   	push   %eax
80103967:	ff 73 04             	pushl  0x4(%ebx)
8010396a:	e8 f1 32 00 00       	call   80106c60 <deallocuvm>
8010396f:	83 c4 10             	add    $0x10,%esp
80103972:	85 c0                	test   %eax,%eax
80103974:	75 b0                	jne    80103926 <growproc+0x26>
80103976:	eb de                	jmp    80103956 <growproc+0x56>
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <fork>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103989:	e8 d2 09 00 00       	call   80104360 <pushcli>
  c = mycpu();
8010398e:	e8 bd fd ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103993:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103999:	e8 02 0a 00 00       	call   801043a0 <popcli>
  if((np = allocproc()) == 0){
8010399e:	e8 5d fc ff ff       	call   80103600 <allocproc>
801039a3:	85 c0                	test   %eax,%eax
801039a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039a8:	0f 84 b7 00 00 00    	je     80103a65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039ae:	83 ec 08             	sub    $0x8,%esp
801039b1:	ff 33                	pushl  (%ebx)
801039b3:	ff 73 04             	pushl  0x4(%ebx)
801039b6:	89 c7                	mov    %eax,%edi
801039b8:	e8 23 34 00 00       	call   80106de0 <copyuvm>
801039bd:	83 c4 10             	add    $0x10,%esp
801039c0:	85 c0                	test   %eax,%eax
801039c2:	89 47 04             	mov    %eax,0x4(%edi)
801039c5:	0f 84 a1 00 00 00    	je     80103a6c <fork+0xec>
  np->sz = curproc->sz;
801039cb:	8b 03                	mov    (%ebx),%eax
801039cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039d0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039d2:	89 59 14             	mov    %ebx,0x14(%ecx)
801039d5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
801039d7:	8b 79 18             	mov    0x18(%ecx),%edi
801039da:	8b 73 18             	mov    0x18(%ebx),%esi
801039dd:	b9 13 00 00 00       	mov    $0x13,%ecx
801039e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801039e4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801039e6:	8b 40 18             	mov    0x18(%eax),%eax
801039e9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801039f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039f4:	85 c0                	test   %eax,%eax
801039f6:	74 13                	je     80103a0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039f8:	83 ec 0c             	sub    $0xc,%esp
801039fb:	50                   	push   %eax
801039fc:	e8 ef d3 ff ff       	call   80100df0 <filedup>
80103a01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a04:	83 c4 10             	add    $0x10,%esp
80103a07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a0b:	83 c6 01             	add    $0x1,%esi
80103a0e:	83 fe 10             	cmp    $0x10,%esi
80103a11:	75 dd                	jne    801039f0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a13:	83 ec 0c             	sub    $0xc,%esp
80103a16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103a1c:	e8 2f dc ff ff       	call   80101650 <idup>
80103a21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	53                   	push   %ebx
80103a30:	50                   	push   %eax
80103a31:	e8 ea 0c 00 00       	call   80104720 <safestrcpy>
  pid = np->pid;
80103a36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103a39:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80103a40:	e8 eb 09 00 00       	call   80104430 <acquire>
  np->state = RUNNABLE;
80103a45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103a4c:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80103a53:	e8 98 0a 00 00       	call   801044f0 <release>
  return pid;
80103a58:	83 c4 10             	add    $0x10,%esp
}
80103a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a5e:	89 d8                	mov    %ebx,%eax
80103a60:	5b                   	pop    %ebx
80103a61:	5e                   	pop    %esi
80103a62:	5f                   	pop    %edi
80103a63:	5d                   	pop    %ebp
80103a64:	c3                   	ret    
    return -1;
80103a65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a6a:	eb ef                	jmp    80103a5b <fork+0xdb>
    kfree(np->kstack);
80103a6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103a6f:	83 ec 0c             	sub    $0xc,%esp
80103a72:	ff 73 08             	pushl  0x8(%ebx)
80103a75:	e8 96 e8 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103a7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103a81:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a90:	eb c9                	jmp    80103a5b <fork+0xdb>
80103a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <scheduler>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103aa9:	e8 a2 fc ff ff       	call   80103750 <mycpu>
80103aae:	8d 70 04             	lea    0x4(%eax),%esi
80103ab1:	89 c3                	mov    %eax,%ebx
  asm volatile("sti");
80103ab3:	fb                   	sti    
    acquire(&ptable.lock);
80103ab4:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab7:	bf 34 29 11 80       	mov    $0x80112934,%edi
    acquire(&ptable.lock);
80103abc:	68 00 29 11 80       	push   $0x80112900
80103ac1:	e8 6a 09 00 00       	call   80104430 <acquire>
80103ac6:	83 c4 10             	add    $0x10,%esp
80103ac9:	eb 10                	jmp    80103adb <scheduler+0x3b>
80103acb:	90                   	nop
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ad0:	83 ef 80             	sub    $0xffffff80,%edi
80103ad3:	81 ff 34 49 11 80    	cmp    $0x80114934,%edi
80103ad9:	73 6c                	jae    80103b47 <scheduler+0xa7>
      if(p->state != RUNNABLE)
80103adb:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103adf:	75 ef                	jne    80103ad0 <scheduler+0x30>
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++) {
80103ae1:	b8 34 29 11 80       	mov    $0x80112934,%eax
80103ae6:	8d 76 00             	lea    0x0(%esi),%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if(p1->state != RUNNABLE)
80103af0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103af4:	75 09                	jne    80103aff <scheduler+0x5f>
        if( highP->priority > p1->priority )  //larger value, lower priority
80103af6:	8b 50 7c             	mov    0x7c(%eax),%edx
80103af9:	39 57 7c             	cmp    %edx,0x7c(%edi)
80103afc:	0f 4f f8             	cmovg  %eax,%edi
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++) {
80103aff:	83 e8 80             	sub    $0xffffff80,%eax
80103b02:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103b07:	72 e7                	jb     80103af0 <scheduler+0x50>
      switchuvm(p);
80103b09:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b0c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103b12:	57                   	push   %edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b13:	83 ef 80             	sub    $0xffffff80,%edi
      switchuvm(p);
80103b16:	e8 c5 2d 00 00       	call   801068e0 <switchuvm>
      p->state = RUNNING;
80103b1b:	c7 47 8c 04 00 00 00 	movl   $0x4,-0x74(%edi)
      swtch(&(c->scheduler), p->context);
80103b22:	58                   	pop    %eax
80103b23:	5a                   	pop    %edx
80103b24:	ff 77 9c             	pushl  -0x64(%edi)
80103b27:	56                   	push   %esi
80103b28:	e8 4e 0c 00 00       	call   8010477b <swtch>
      switchkvm();
80103b2d:	e8 8e 2d 00 00       	call   801068c0 <switchkvm>
      c->proc = 0;
80103b32:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b35:	81 ff 34 49 11 80    	cmp    $0x80114934,%edi
      c->proc = 0;
80103b3b:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103b42:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b45:	72 94                	jb     80103adb <scheduler+0x3b>
    release(&ptable.lock);
80103b47:	83 ec 0c             	sub    $0xc,%esp
80103b4a:	68 00 29 11 80       	push   $0x80112900
80103b4f:	e8 9c 09 00 00       	call   801044f0 <release>
  for(;;){
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	e9 57 ff ff ff       	jmp    80103ab3 <scheduler+0x13>
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b60 <sched>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
  pushcli();
80103b65:	e8 f6 07 00 00       	call   80104360 <pushcli>
  c = mycpu();
80103b6a:	e8 e1 fb ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103b6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b75:	e8 26 08 00 00       	call   801043a0 <popcli>
  if(!holding(&ptable.lock))
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 00 29 11 80       	push   $0x80112900
80103b82:	e8 79 08 00 00       	call   80104400 <holding>
80103b87:	83 c4 10             	add    $0x10,%esp
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	74 4f                	je     80103bdd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103b8e:	e8 bd fb ff ff       	call   80103750 <mycpu>
80103b93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b9a:	75 68                	jne    80103c04 <sched+0xa4>
  if(p->state == RUNNING)
80103b9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ba0:	74 55                	je     80103bf7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba2:	9c                   	pushf  
80103ba3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ba4:	f6 c4 02             	test   $0x2,%ah
80103ba7:	75 41                	jne    80103bea <sched+0x8a>
  intena = mycpu()->intena;
80103ba9:	e8 a2 fb ff ff       	call   80103750 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103bb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bb7:	e8 94 fb ff ff       	call   80103750 <mycpu>
80103bbc:	83 ec 08             	sub    $0x8,%esp
80103bbf:	ff 70 04             	pushl  0x4(%eax)
80103bc2:	53                   	push   %ebx
80103bc3:	e8 b3 0b 00 00       	call   8010477b <swtch>
  mycpu()->intena = intena;
80103bc8:	e8 83 fb ff ff       	call   80103750 <mycpu>
}
80103bcd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103bd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd9:	5b                   	pop    %ebx
80103bda:	5e                   	pop    %esi
80103bdb:	5d                   	pop    %ebp
80103bdc:	c3                   	ret    
    panic("sched ptable.lock");
80103bdd:	83 ec 0c             	sub    $0xc,%esp
80103be0:	68 50 75 10 80       	push   $0x80107550
80103be5:	e8 a6 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	68 7c 75 10 80       	push   $0x8010757c
80103bf2:	e8 99 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103bf7:	83 ec 0c             	sub    $0xc,%esp
80103bfa:	68 6e 75 10 80       	push   $0x8010756e
80103bff:	e8 8c c7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103c04:	83 ec 0c             	sub    $0xc,%esp
80103c07:	68 62 75 10 80       	push   $0x80107562
80103c0c:	e8 7f c7 ff ff       	call   80100390 <panic>
80103c11:	eb 0d                	jmp    80103c20 <exit>
80103c13:	90                   	nop
80103c14:	90                   	nop
80103c15:	90                   	nop
80103c16:	90                   	nop
80103c17:	90                   	nop
80103c18:	90                   	nop
80103c19:	90                   	nop
80103c1a:	90                   	nop
80103c1b:	90                   	nop
80103c1c:	90                   	nop
80103c1d:	90                   	nop
80103c1e:	90                   	nop
80103c1f:	90                   	nop

80103c20 <exit>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c29:	e8 32 07 00 00       	call   80104360 <pushcli>
  c = mycpu();
80103c2e:	e8 1d fb ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103c33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c39:	e8 62 07 00 00       	call   801043a0 <popcli>
  if(curproc == initproc)
80103c3e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c44:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c47:	8d 7e 68             	lea    0x68(%esi),%edi
80103c4a:	0f 84 e7 00 00 00    	je     80103d37 <exit+0x117>
    if(curproc->ofile[fd]){
80103c50:	8b 03                	mov    (%ebx),%eax
80103c52:	85 c0                	test   %eax,%eax
80103c54:	74 12                	je     80103c68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c56:	83 ec 0c             	sub    $0xc,%esp
80103c59:	50                   	push   %eax
80103c5a:	e8 e1 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103c5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103c6b:	39 fb                	cmp    %edi,%ebx
80103c6d:	75 e1                	jne    80103c50 <exit+0x30>
  begin_op();
80103c6f:	e8 2c ef ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103c74:	83 ec 0c             	sub    $0xc,%esp
80103c77:	ff 76 68             	pushl  0x68(%esi)
80103c7a:	e8 31 db ff ff       	call   801017b0 <iput>
  end_op();
80103c7f:	e8 8c ef ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103c84:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103c8b:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80103c92:	e8 99 07 00 00       	call   80104430 <acquire>
  wakeup1(curproc->parent);
80103c97:	8b 56 14             	mov    0x14(%esi),%edx
80103c9a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c9d:	b8 34 29 11 80       	mov    $0x80112934,%eax
80103ca2:	eb 0e                	jmp    80103cb2 <exit+0x92>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	83 e8 80             	sub    $0xffffff80,%eax
80103cab:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103cb0:	73 1c                	jae    80103cce <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103cb2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cb6:	75 f0                	jne    80103ca8 <exit+0x88>
80103cb8:	3b 50 20             	cmp    0x20(%eax),%edx
80103cbb:	75 eb                	jne    80103ca8 <exit+0x88>
      p->state = RUNNABLE;
80103cbd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cc4:	83 e8 80             	sub    $0xffffff80,%eax
80103cc7:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103ccc:	72 e4                	jb     80103cb2 <exit+0x92>
      p->parent = initproc;
80103cce:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd4:	ba 34 29 11 80       	mov    $0x80112934,%edx
80103cd9:	eb 10                	jmp    80103ceb <exit+0xcb>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce0:	83 ea 80             	sub    $0xffffff80,%edx
80103ce3:	81 fa 34 49 11 80    	cmp    $0x80114934,%edx
80103ce9:	73 33                	jae    80103d1e <exit+0xfe>
    if(p->parent == curproc){
80103ceb:	39 72 14             	cmp    %esi,0x14(%edx)
80103cee:	75 f0                	jne    80103ce0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103cf0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103cf4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103cf7:	75 e7                	jne    80103ce0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf9:	b8 34 29 11 80       	mov    $0x80112934,%eax
80103cfe:	eb 0a                	jmp    80103d0a <exit+0xea>
80103d00:	83 e8 80             	sub    $0xffffff80,%eax
80103d03:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103d08:	73 d6                	jae    80103ce0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d0e:	75 f0                	jne    80103d00 <exit+0xe0>
80103d10:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d13:	75 eb                	jne    80103d00 <exit+0xe0>
      p->state = RUNNABLE;
80103d15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d1c:	eb e2                	jmp    80103d00 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d1e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d25:	e8 36 fe ff ff       	call   80103b60 <sched>
  panic("zombie exit");
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	68 9d 75 10 80       	push   $0x8010759d
80103d32:	e8 59 c6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	68 90 75 10 80       	push   $0x80107590
80103d3f:	e8 4c c6 ff ff       	call   80100390 <panic>
80103d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d50 <yield>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	53                   	push   %ebx
80103d54:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d57:	68 00 29 11 80       	push   $0x80112900
80103d5c:	e8 cf 06 00 00       	call   80104430 <acquire>
  pushcli();
80103d61:	e8 fa 05 00 00       	call   80104360 <pushcli>
  c = mycpu();
80103d66:	e8 e5 f9 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103d6b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d71:	e8 2a 06 00 00       	call   801043a0 <popcli>
  myproc()->state = RUNNABLE;
80103d76:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d7d:	e8 de fd ff ff       	call   80103b60 <sched>
  release(&ptable.lock);
80103d82:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80103d89:	e8 62 07 00 00       	call   801044f0 <release>
}
80103d8e:	83 c4 10             	add    $0x10,%esp
80103d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d94:	c9                   	leave  
80103d95:	c3                   	ret    
80103d96:	8d 76 00             	lea    0x0(%esi),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <sleep>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103daf:	e8 ac 05 00 00       	call   80104360 <pushcli>
  c = mycpu();
80103db4:	e8 97 f9 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103db9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dbf:	e8 dc 05 00 00       	call   801043a0 <popcli>
  if(p == 0)
80103dc4:	85 db                	test   %ebx,%ebx
80103dc6:	0f 84 87 00 00 00    	je     80103e53 <sleep+0xb3>
  if(lk == 0)
80103dcc:	85 f6                	test   %esi,%esi
80103dce:	74 76                	je     80103e46 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103dd0:	81 fe 00 29 11 80    	cmp    $0x80112900,%esi
80103dd6:	74 50                	je     80103e28 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 00 29 11 80       	push   $0x80112900
80103de0:	e8 4b 06 00 00       	call   80104430 <acquire>
    release(lk);
80103de5:	89 34 24             	mov    %esi,(%esp)
80103de8:	e8 03 07 00 00       	call   801044f0 <release>
  p->chan = chan;
80103ded:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103df0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103df7:	e8 64 fd ff ff       	call   80103b60 <sched>
  p->chan = 0;
80103dfc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e03:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
80103e0a:	e8 e1 06 00 00       	call   801044f0 <release>
    acquire(lk);
80103e0f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e12:	83 c4 10             	add    $0x10,%esp
}
80103e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e18:	5b                   	pop    %ebx
80103e19:	5e                   	pop    %esi
80103e1a:	5f                   	pop    %edi
80103e1b:	5d                   	pop    %ebp
    acquire(lk);
80103e1c:	e9 0f 06 00 00       	jmp    80104430 <acquire>
80103e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e28:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e2b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e32:	e8 29 fd ff ff       	call   80103b60 <sched>
  p->chan = 0;
80103e37:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e41:	5b                   	pop    %ebx
80103e42:	5e                   	pop    %esi
80103e43:	5f                   	pop    %edi
80103e44:	5d                   	pop    %ebp
80103e45:	c3                   	ret    
    panic("sleep without lk");
80103e46:	83 ec 0c             	sub    $0xc,%esp
80103e49:	68 af 75 10 80       	push   $0x801075af
80103e4e:	e8 3d c5 ff ff       	call   80100390 <panic>
    panic("sleep");
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	68 a9 75 10 80       	push   $0x801075a9
80103e5b:	e8 30 c5 ff ff       	call   80100390 <panic>

80103e60 <wait>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
  pushcli();
80103e65:	e8 f6 04 00 00       	call   80104360 <pushcli>
  c = mycpu();
80103e6a:	e8 e1 f8 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103e6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e75:	e8 26 05 00 00       	call   801043a0 <popcli>
  acquire(&ptable.lock);
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 00 29 11 80       	push   $0x80112900
80103e82:	e8 a9 05 00 00       	call   80104430 <acquire>
80103e87:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103e8a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	bb 34 29 11 80       	mov    $0x80112934,%ebx
80103e91:	eb 10                	jmp    80103ea3 <wait+0x43>
80103e93:	90                   	nop
80103e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e98:	83 eb 80             	sub    $0xffffff80,%ebx
80103e9b:	81 fb 34 49 11 80    	cmp    $0x80114934,%ebx
80103ea1:	73 1b                	jae    80103ebe <wait+0x5e>
      if(p->parent != curproc)
80103ea3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ea6:	75 f0                	jne    80103e98 <wait+0x38>
      if(p->state == ZOMBIE){
80103ea8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eac:	74 32                	je     80103ee0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eae:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103eb1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb6:	81 fb 34 49 11 80    	cmp    $0x80114934,%ebx
80103ebc:	72 e5                	jb     80103ea3 <wait+0x43>
    if(!havekids || curproc->killed){
80103ebe:	85 c0                	test   %eax,%eax
80103ec0:	74 74                	je     80103f36 <wait+0xd6>
80103ec2:	8b 46 24             	mov    0x24(%esi),%eax
80103ec5:	85 c0                	test   %eax,%eax
80103ec7:	75 6d                	jne    80103f36 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ec9:	83 ec 08             	sub    $0x8,%esp
80103ecc:	68 00 29 11 80       	push   $0x80112900
80103ed1:	56                   	push   %esi
80103ed2:	e8 c9 fe ff ff       	call   80103da0 <sleep>
    havekids = 0;
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	eb ae                	jmp    80103e8a <wait+0x2a>
80103edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103ee6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ee9:	e8 22 e4 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103eee:	5a                   	pop    %edx
80103eef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103ef2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ef9:	e8 92 2d 00 00       	call   80106c90 <freevm>
        release(&ptable.lock);
80103efe:	c7 04 24 00 29 11 80 	movl   $0x80112900,(%esp)
        p->pid = 0;
80103f05:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f0c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f13:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f17:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f1e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f25:	e8 c6 05 00 00       	call   801044f0 <release>
        return pid;
80103f2a:	83 c4 10             	add    $0x10,%esp
}
80103f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f30:	89 f0                	mov    %esi,%eax
80103f32:	5b                   	pop    %ebx
80103f33:	5e                   	pop    %esi
80103f34:	5d                   	pop    %ebp
80103f35:	c3                   	ret    
      release(&ptable.lock);
80103f36:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f39:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f3e:	68 00 29 11 80       	push   $0x80112900
80103f43:	e8 a8 05 00 00       	call   801044f0 <release>
      return -1;
80103f48:	83 c4 10             	add    $0x10,%esp
80103f4b:	eb e0                	jmp    80103f2d <wait+0xcd>
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi

80103f50 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 10             	sub    $0x10,%esp
80103f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f5a:	68 00 29 11 80       	push   $0x80112900
80103f5f:	e8 cc 04 00 00       	call   80104430 <acquire>
80103f64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f67:	b8 34 29 11 80       	mov    $0x80112934,%eax
80103f6c:	eb 0c                	jmp    80103f7a <wakeup+0x2a>
80103f6e:	66 90                	xchg   %ax,%ax
80103f70:	83 e8 80             	sub    $0xffffff80,%eax
80103f73:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103f78:	73 1c                	jae    80103f96 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103f7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f7e:	75 f0                	jne    80103f70 <wakeup+0x20>
80103f80:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f83:	75 eb                	jne    80103f70 <wakeup+0x20>
      p->state = RUNNABLE;
80103f85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f8c:	83 e8 80             	sub    $0xffffff80,%eax
80103f8f:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103f94:	72 e4                	jb     80103f7a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103f96:	c7 45 08 00 29 11 80 	movl   $0x80112900,0x8(%ebp)
}
80103f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fa0:	c9                   	leave  
  release(&ptable.lock);
80103fa1:	e9 4a 05 00 00       	jmp    801044f0 <release>
80103fa6:	8d 76 00             	lea    0x0(%esi),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 10             	sub    $0x10,%esp
80103fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103fba:	68 00 29 11 80       	push   $0x80112900
80103fbf:	e8 6c 04 00 00       	call   80104430 <acquire>
80103fc4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc7:	b8 34 29 11 80       	mov    $0x80112934,%eax
80103fcc:	eb 0c                	jmp    80103fda <kill+0x2a>
80103fce:	66 90                	xchg   %ax,%ax
80103fd0:	83 e8 80             	sub    $0xffffff80,%eax
80103fd3:	3d 34 49 11 80       	cmp    $0x80114934,%eax
80103fd8:	73 36                	jae    80104010 <kill+0x60>
    if(p->pid == pid){
80103fda:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fdd:	75 f1                	jne    80103fd0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fdf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103fe3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103fea:	75 07                	jne    80103ff3 <kill+0x43>
        p->state = RUNNABLE;
80103fec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103ff3:	83 ec 0c             	sub    $0xc,%esp
80103ff6:	68 00 29 11 80       	push   $0x80112900
80103ffb:	e8 f0 04 00 00       	call   801044f0 <release>
      return 0;
80104000:	83 c4 10             	add    $0x10,%esp
80104003:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104008:	c9                   	leave  
80104009:	c3                   	ret    
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104010:	83 ec 0c             	sub    $0xc,%esp
80104013:	68 00 29 11 80       	push   $0x80112900
80104018:	e8 d3 04 00 00       	call   801044f0 <release>
  return -1;
8010401d:	83 c4 10             	add    $0x10,%esp
80104020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104028:	c9                   	leave  
80104029:	c3                   	ret    
8010402a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104030 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104039:	bb 34 29 11 80       	mov    $0x80112934,%ebx
{
8010403e:	83 ec 3c             	sub    $0x3c,%esp
80104041:	eb 24                	jmp    80104067 <procdump+0x37>
80104043:	90                   	nop
80104044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104048:	83 ec 0c             	sub    $0xc,%esp
8010404b:	68 29 76 10 80       	push   $0x80107629
80104050:	e8 0b c6 ff ff       	call   80100660 <cprintf>
80104055:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104058:	83 eb 80             	sub    $0xffffff80,%ebx
8010405b:	81 fb 34 49 11 80    	cmp    $0x80114934,%ebx
80104061:	0f 83 81 00 00 00    	jae    801040e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104067:	8b 43 0c             	mov    0xc(%ebx),%eax
8010406a:	85 c0                	test   %eax,%eax
8010406c:	74 ea                	je     80104058 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010406e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104071:	ba c0 75 10 80       	mov    $0x801075c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104076:	77 11                	ja     80104089 <procdump+0x59>
80104078:	8b 14 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%edx
      state = "???";
8010407f:	b8 c0 75 10 80       	mov    $0x801075c0,%eax
80104084:	85 d2                	test   %edx,%edx
80104086:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104089:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010408c:	50                   	push   %eax
8010408d:	52                   	push   %edx
8010408e:	ff 73 10             	pushl  0x10(%ebx)
80104091:	68 c4 75 10 80       	push   $0x801075c4
80104096:	e8 c5 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010409b:	83 c4 10             	add    $0x10,%esp
8010409e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801040a2:	75 a4                	jne    80104048 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040a7:	83 ec 08             	sub    $0x8,%esp
801040aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040ad:	50                   	push   %eax
801040ae:	8b 43 1c             	mov    0x1c(%ebx),%eax
801040b1:	8b 40 0c             	mov    0xc(%eax),%eax
801040b4:	83 c0 08             	add    $0x8,%eax
801040b7:	50                   	push   %eax
801040b8:	e8 53 02 00 00       	call   80104310 <getcallerpcs>
801040bd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801040c0:	8b 17                	mov    (%edi),%edx
801040c2:	85 d2                	test   %edx,%edx
801040c4:	74 82                	je     80104048 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040c6:	83 ec 08             	sub    $0x8,%esp
801040c9:	83 c7 04             	add    $0x4,%edi
801040cc:	52                   	push   %edx
801040cd:	68 01 70 10 80       	push   $0x80107001
801040d2:	e8 89 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801040d7:	83 c4 10             	add    $0x10,%esp
801040da:	39 fe                	cmp    %edi,%esi
801040dc:	75 e2                	jne    801040c0 <procdump+0x90>
801040de:	e9 65 ff ff ff       	jmp    80104048 <procdump+0x18>
801040e3:	90                   	nop
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801040e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040eb:	5b                   	pop    %ebx
801040ec:	5e                   	pop    %esi
801040ed:	5f                   	pop    %edi
801040ee:	5d                   	pop    %ebp
801040ef:	c3                   	ret    

801040f0 <cps>:

//Current Process State function to gether all the states
int
cps() {
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
801040f7:	fb                   	sti    
  struct proc *p;

  // Enable interrupts on the processor
  sti();

  acquire(&ptable.lock);
801040f8:	68 00 29 11 80       	push   $0x80112900
  cprintf("name \t pid \t state \t \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040fd:	bb 34 29 11 80       	mov    $0x80112934,%ebx
  acquire(&ptable.lock);
80104102:	e8 29 03 00 00       	call   80104430 <acquire>
  cprintf("name \t pid \t state \t \n");
80104107:	c7 04 24 cd 75 10 80 	movl   $0x801075cd,(%esp)
8010410e:	e8 4d c5 ff ff       	call   80100660 <cprintf>
80104113:	83 c4 10             	add    $0x10,%esp
80104116:	eb 1d                	jmp    80104135 <cps+0x45>
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if( p->state == SLEEPING ) 
      cprintf("%s \t %d  \t SLEEPING \t \n",p->name, p->pid);
    else if( p->state == RUNNING ) 
80104120:	83 f8 04             	cmp    $0x4,%eax
80104123:	74 5b                	je     80104180 <cps+0x90>
      cprintf("%s \t %d  \t RUNNING \t \n",p->name, p->pid);
    else if( p->state == RUNNABLE ) 
80104125:	83 f8 03             	cmp    $0x3,%eax
80104128:	74 76                	je     801041a0 <cps+0xb0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010412a:	83 eb 80             	sub    $0xffffff80,%ebx
8010412d:	81 fb 34 49 11 80    	cmp    $0x80114934,%ebx
80104133:	73 2a                	jae    8010415f <cps+0x6f>
    if( p->state == SLEEPING ) 
80104135:	8b 43 0c             	mov    0xc(%ebx),%eax
80104138:	83 f8 02             	cmp    $0x2,%eax
8010413b:	75 e3                	jne    80104120 <cps+0x30>
      cprintf("%s \t %d  \t SLEEPING \t \n",p->name, p->pid);
8010413d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104140:	83 ec 04             	sub    $0x4,%esp
80104143:	ff 73 10             	pushl  0x10(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104146:	83 eb 80             	sub    $0xffffff80,%ebx
      cprintf("%s \t %d  \t SLEEPING \t \n",p->name, p->pid);
80104149:	50                   	push   %eax
8010414a:	68 e4 75 10 80       	push   $0x801075e4
8010414f:	e8 0c c5 ff ff       	call   80100660 <cprintf>
80104154:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104157:	81 fb 34 49 11 80    	cmp    $0x80114934,%ebx
8010415d:	72 d6                	jb     80104135 <cps+0x45>
      cprintf("%s \t %d  \t RUNNABLE \t \n",p->name, p->pid);    
  }

  release(&ptable.lock);
8010415f:	83 ec 0c             	sub    $0xc,%esp
80104162:	68 00 29 11 80       	push   $0x80112900
80104167:	e8 84 03 00 00       	call   801044f0 <release>

  return 22;
}
8010416c:	b8 16 00 00 00       	mov    $0x16,%eax
80104171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104174:	c9                   	leave  
80104175:	c3                   	ret    
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("%s \t %d  \t RUNNING \t \n",p->name, p->pid);
80104180:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104183:	83 ec 04             	sub    $0x4,%esp
80104186:	ff 73 10             	pushl  0x10(%ebx)
80104189:	50                   	push   %eax
8010418a:	68 fc 75 10 80       	push   $0x801075fc
8010418f:	e8 cc c4 ff ff       	call   80100660 <cprintf>
80104194:	83 c4 10             	add    $0x10,%esp
80104197:	eb 91                	jmp    8010412a <cps+0x3a>
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("%s \t %d  \t RUNNABLE \t \n",p->name, p->pid);    
801041a0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041a3:	83 ec 04             	sub    $0x4,%esp
801041a6:	ff 73 10             	pushl  0x10(%ebx)
801041a9:	50                   	push   %eax
801041aa:	68 13 76 10 80       	push   $0x80107613
801041af:	e8 ac c4 ff ff       	call   80100660 <cprintf>
801041b4:	83 c4 10             	add    $0x10,%esp
801041b7:	e9 6e ff ff ff       	jmp    8010412a <cps+0x3a>
801041bc:	66 90                	xchg   %ax,%ax
801041be:	66 90                	xchg   %ax,%ax

801041c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 0c             	sub    $0xc,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801041ca:	68 98 76 10 80       	push   $0x80107698
801041cf:	8d 43 04             	lea    0x4(%ebx),%eax
801041d2:	50                   	push   %eax
801041d3:	e8 18 01 00 00       	call   801042f0 <initlock>
  lk->name = name;
801041d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801041db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801041e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801041e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801041eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801041ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041f1:	c9                   	leave  
801041f2:	c3                   	ret    
801041f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104200 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	56                   	push   %esi
80104204:	53                   	push   %ebx
80104205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	8d 73 04             	lea    0x4(%ebx),%esi
8010420e:	56                   	push   %esi
8010420f:	e8 1c 02 00 00       	call   80104430 <acquire>
  while (lk->locked) {
80104214:	8b 13                	mov    (%ebx),%edx
80104216:	83 c4 10             	add    $0x10,%esp
80104219:	85 d2                	test   %edx,%edx
8010421b:	74 16                	je     80104233 <acquiresleep+0x33>
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104220:	83 ec 08             	sub    $0x8,%esp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	e8 76 fb ff ff       	call   80103da0 <sleep>
  while (lk->locked) {
8010422a:	8b 03                	mov    (%ebx),%eax
8010422c:	83 c4 10             	add    $0x10,%esp
8010422f:	85 c0                	test   %eax,%eax
80104231:	75 ed                	jne    80104220 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104233:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104239:	e8 a2 f5 ff ff       	call   801037e0 <myproc>
8010423e:	8b 40 10             	mov    0x10(%eax),%eax
80104241:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104244:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104247:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010424a:	5b                   	pop    %ebx
8010424b:	5e                   	pop    %esi
8010424c:	5d                   	pop    %ebp
  release(&lk->lk);
8010424d:	e9 9e 02 00 00       	jmp    801044f0 <release>
80104252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104260 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
80104265:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	8d 73 04             	lea    0x4(%ebx),%esi
8010426e:	56                   	push   %esi
8010426f:	e8 bc 01 00 00       	call   80104430 <acquire>
  lk->locked = 0;
80104274:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010427a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104281:	89 1c 24             	mov    %ebx,(%esp)
80104284:	e8 c7 fc ff ff       	call   80103f50 <wakeup>
  release(&lk->lk);
80104289:	89 75 08             	mov    %esi,0x8(%ebp)
8010428c:	83 c4 10             	add    $0x10,%esp
}
8010428f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104292:	5b                   	pop    %ebx
80104293:	5e                   	pop    %esi
80104294:	5d                   	pop    %ebp
  release(&lk->lk);
80104295:	e9 56 02 00 00       	jmp    801044f0 <release>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	31 ff                	xor    %edi,%edi
801042a8:	83 ec 18             	sub    $0x18,%esp
801042ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801042ae:	8d 73 04             	lea    0x4(%ebx),%esi
801042b1:	56                   	push   %esi
801042b2:	e8 79 01 00 00       	call   80104430 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801042b7:	8b 03                	mov    (%ebx),%eax
801042b9:	83 c4 10             	add    $0x10,%esp
801042bc:	85 c0                	test   %eax,%eax
801042be:	74 13                	je     801042d3 <holdingsleep+0x33>
801042c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801042c3:	e8 18 f5 ff ff       	call   801037e0 <myproc>
801042c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801042cb:	0f 94 c0             	sete   %al
801042ce:	0f b6 c0             	movzbl %al,%eax
801042d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	56                   	push   %esi
801042d7:	e8 14 02 00 00       	call   801044f0 <release>
  return r;
}
801042dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042df:	89 f8                	mov    %edi,%eax
801042e1:	5b                   	pop    %ebx
801042e2:	5e                   	pop    %esi
801042e3:	5f                   	pop    %edi
801042e4:	5d                   	pop    %ebp
801042e5:	c3                   	ret    
801042e6:	66 90                	xchg   %ax,%ax
801042e8:	66 90                	xchg   %ax,%ax
801042ea:	66 90                	xchg   %ax,%ax
801042ec:	66 90                	xchg   %ax,%ax
801042ee:	66 90                	xchg   %ax,%ax

801042f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801042f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801042f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801042ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104302:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104309:	5d                   	pop    %ebp
8010430a:	c3                   	ret    
8010430b:	90                   	nop
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104310 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104310:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104311:	31 d2                	xor    %edx,%edx
{
80104313:	89 e5                	mov    %esp,%ebp
80104315:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104316:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010431c:	83 e8 08             	sub    $0x8,%eax
8010431f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104320:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104326:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010432c:	77 1a                	ja     80104348 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010432e:	8b 58 04             	mov    0x4(%eax),%ebx
80104331:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104334:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104337:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104339:	83 fa 0a             	cmp    $0xa,%edx
8010433c:	75 e2                	jne    80104320 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010433e:	5b                   	pop    %ebx
8010433f:	5d                   	pop    %ebp
80104340:	c3                   	ret    
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104348:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010434b:	83 c1 28             	add    $0x28,%ecx
8010434e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104356:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104359:	39 c1                	cmp    %eax,%ecx
8010435b:	75 f3                	jne    80104350 <getcallerpcs+0x40>
}
8010435d:	5b                   	pop    %ebx
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret    

80104360 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104367:	9c                   	pushf  
80104368:	5b                   	pop    %ebx
  asm volatile("cli");
80104369:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010436a:	e8 e1 f3 ff ff       	call   80103750 <mycpu>
8010436f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104375:	85 c0                	test   %eax,%eax
80104377:	75 11                	jne    8010438a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104379:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010437f:	e8 cc f3 ff ff       	call   80103750 <mycpu>
80104384:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010438a:	e8 c1 f3 ff ff       	call   80103750 <mycpu>
8010438f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104396:	83 c4 04             	add    $0x4,%esp
80104399:	5b                   	pop    %ebx
8010439a:	5d                   	pop    %ebp
8010439b:	c3                   	ret    
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043a0 <popcli>:

void
popcli(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043a6:	9c                   	pushf  
801043a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043a8:	f6 c4 02             	test   $0x2,%ah
801043ab:	75 35                	jne    801043e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801043ad:	e8 9e f3 ff ff       	call   80103750 <mycpu>
801043b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801043b9:	78 34                	js     801043ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801043bb:	e8 90 f3 ff ff       	call   80103750 <mycpu>
801043c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801043c6:	85 d2                	test   %edx,%edx
801043c8:	74 06                	je     801043d0 <popcli+0x30>
    sti();
}
801043ca:	c9                   	leave  
801043cb:	c3                   	ret    
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801043d0:	e8 7b f3 ff ff       	call   80103750 <mycpu>
801043d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801043db:	85 c0                	test   %eax,%eax
801043dd:	74 eb                	je     801043ca <popcli+0x2a>
  asm volatile("sti");
801043df:	fb                   	sti    
}
801043e0:	c9                   	leave  
801043e1:	c3                   	ret    
    panic("popcli - interruptible");
801043e2:	83 ec 0c             	sub    $0xc,%esp
801043e5:	68 a3 76 10 80       	push   $0x801076a3
801043ea:	e8 a1 bf ff ff       	call   80100390 <panic>
    panic("popcli");
801043ef:	83 ec 0c             	sub    $0xc,%esp
801043f2:	68 ba 76 10 80       	push   $0x801076ba
801043f7:	e8 94 bf ff ff       	call   80100390 <panic>
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104400 <holding>:
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 75 08             	mov    0x8(%ebp),%esi
80104408:	31 db                	xor    %ebx,%ebx
  pushcli();
8010440a:	e8 51 ff ff ff       	call   80104360 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010440f:	8b 06                	mov    (%esi),%eax
80104411:	85 c0                	test   %eax,%eax
80104413:	74 10                	je     80104425 <holding+0x25>
80104415:	8b 5e 08             	mov    0x8(%esi),%ebx
80104418:	e8 33 f3 ff ff       	call   80103750 <mycpu>
8010441d:	39 c3                	cmp    %eax,%ebx
8010441f:	0f 94 c3             	sete   %bl
80104422:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104425:	e8 76 ff ff ff       	call   801043a0 <popcli>
}
8010442a:	89 d8                	mov    %ebx,%eax
8010442c:	5b                   	pop    %ebx
8010442d:	5e                   	pop    %esi
8010442e:	5d                   	pop    %ebp
8010442f:	c3                   	ret    

80104430 <acquire>:
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104435:	e8 26 ff ff ff       	call   80104360 <pushcli>
  if(holding(lk))
8010443a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010443d:	83 ec 0c             	sub    $0xc,%esp
80104440:	53                   	push   %ebx
80104441:	e8 ba ff ff ff       	call   80104400 <holding>
80104446:	83 c4 10             	add    $0x10,%esp
80104449:	85 c0                	test   %eax,%eax
8010444b:	0f 85 83 00 00 00    	jne    801044d4 <acquire+0xa4>
80104451:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104453:	ba 01 00 00 00       	mov    $0x1,%edx
80104458:	eb 09                	jmp    80104463 <acquire+0x33>
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104460:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104463:	89 d0                	mov    %edx,%eax
80104465:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104468:	85 c0                	test   %eax,%eax
8010446a:	75 f4                	jne    80104460 <acquire+0x30>
  __sync_synchronize();
8010446c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104471:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104474:	e8 d7 f2 ff ff       	call   80103750 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104479:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010447c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010447f:	89 e8                	mov    %ebp,%eax
80104481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104488:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010448e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104494:	77 1a                	ja     801044b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104496:	8b 48 04             	mov    0x4(%eax),%ecx
80104499:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010449c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010449f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044a1:	83 fe 0a             	cmp    $0xa,%esi
801044a4:	75 e2                	jne    80104488 <acquire+0x58>
}
801044a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a9:	5b                   	pop    %ebx
801044aa:	5e                   	pop    %esi
801044ab:	5d                   	pop    %ebp
801044ac:	c3                   	ret    
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
801044b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801044b3:	83 c2 28             	add    $0x28,%edx
801044b6:	8d 76 00             	lea    0x0(%esi),%esi
801044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801044c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801044c9:	39 d0                	cmp    %edx,%eax
801044cb:	75 f3                	jne    801044c0 <acquire+0x90>
}
801044cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d0:	5b                   	pop    %ebx
801044d1:	5e                   	pop    %esi
801044d2:	5d                   	pop    %ebp
801044d3:	c3                   	ret    
    panic("acquire");
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	68 c1 76 10 80       	push   $0x801076c1
801044dc:	e8 af be ff ff       	call   80100390 <panic>
801044e1:	eb 0d                	jmp    801044f0 <release>
801044e3:	90                   	nop
801044e4:	90                   	nop
801044e5:	90                   	nop
801044e6:	90                   	nop
801044e7:	90                   	nop
801044e8:	90                   	nop
801044e9:	90                   	nop
801044ea:	90                   	nop
801044eb:	90                   	nop
801044ec:	90                   	nop
801044ed:	90                   	nop
801044ee:	90                   	nop
801044ef:	90                   	nop

801044f0 <release>:
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 10             	sub    $0x10,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801044fa:	53                   	push   %ebx
801044fb:	e8 00 ff ff ff       	call   80104400 <holding>
80104500:	83 c4 10             	add    $0x10,%esp
80104503:	85 c0                	test   %eax,%eax
80104505:	74 22                	je     80104529 <release+0x39>
  lk->pcs[0] = 0;
80104507:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010450e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104515:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010451a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104523:	c9                   	leave  
  popcli();
80104524:	e9 77 fe ff ff       	jmp    801043a0 <popcli>
    panic("release");
80104529:	83 ec 0c             	sub    $0xc,%esp
8010452c:	68 c9 76 10 80       	push   $0x801076c9
80104531:	e8 5a be ff ff       	call   80100390 <panic>
80104536:	66 90                	xchg   %ax,%ax
80104538:	66 90                	xchg   %ax,%ax
8010453a:	66 90                	xchg   %ax,%ax
8010453c:	66 90                	xchg   %ax,%ax
8010453e:	66 90                	xchg   %ax,%ax

80104540 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	53                   	push   %ebx
80104545:	8b 55 08             	mov    0x8(%ebp),%edx
80104548:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010454b:	f6 c2 03             	test   $0x3,%dl
8010454e:	75 05                	jne    80104555 <memset+0x15>
80104550:	f6 c1 03             	test   $0x3,%cl
80104553:	74 13                	je     80104568 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104555:	89 d7                	mov    %edx,%edi
80104557:	8b 45 0c             	mov    0xc(%ebp),%eax
8010455a:	fc                   	cld    
8010455b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010455d:	5b                   	pop    %ebx
8010455e:	89 d0                	mov    %edx,%eax
80104560:	5f                   	pop    %edi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret    
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104568:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010456c:	c1 e9 02             	shr    $0x2,%ecx
8010456f:	89 f8                	mov    %edi,%eax
80104571:	89 fb                	mov    %edi,%ebx
80104573:	c1 e0 18             	shl    $0x18,%eax
80104576:	c1 e3 10             	shl    $0x10,%ebx
80104579:	09 d8                	or     %ebx,%eax
8010457b:	09 f8                	or     %edi,%eax
8010457d:	c1 e7 08             	shl    $0x8,%edi
80104580:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104582:	89 d7                	mov    %edx,%edi
80104584:	fc                   	cld    
80104585:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104587:	5b                   	pop    %ebx
80104588:	89 d0                	mov    %edx,%eax
8010458a:	5f                   	pop    %edi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
8010458d:	8d 76 00             	lea    0x0(%esi),%esi

80104590 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	53                   	push   %ebx
80104596:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104599:	8b 75 08             	mov    0x8(%ebp),%esi
8010459c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010459f:	85 db                	test   %ebx,%ebx
801045a1:	74 29                	je     801045cc <memcmp+0x3c>
    if(*s1 != *s2)
801045a3:	0f b6 16             	movzbl (%esi),%edx
801045a6:	0f b6 0f             	movzbl (%edi),%ecx
801045a9:	38 d1                	cmp    %dl,%cl
801045ab:	75 2b                	jne    801045d8 <memcmp+0x48>
801045ad:	b8 01 00 00 00       	mov    $0x1,%eax
801045b2:	eb 14                	jmp    801045c8 <memcmp+0x38>
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801045bc:	83 c0 01             	add    $0x1,%eax
801045bf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801045c4:	38 ca                	cmp    %cl,%dl
801045c6:	75 10                	jne    801045d8 <memcmp+0x48>
  while(n-- > 0){
801045c8:	39 d8                	cmp    %ebx,%eax
801045ca:	75 ec                	jne    801045b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801045cc:	5b                   	pop    %ebx
  return 0;
801045cd:	31 c0                	xor    %eax,%eax
}
801045cf:	5e                   	pop    %esi
801045d0:	5f                   	pop    %edi
801045d1:	5d                   	pop    %ebp
801045d2:	c3                   	ret    
801045d3:	90                   	nop
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801045d8:	0f b6 c2             	movzbl %dl,%eax
}
801045db:	5b                   	pop    %ebx
      return *s1 - *s2;
801045dc:	29 c8                	sub    %ecx,%eax
}
801045de:	5e                   	pop    %esi
801045df:	5f                   	pop    %edi
801045e0:	5d                   	pop    %ebp
801045e1:	c3                   	ret    
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 45 08             	mov    0x8(%ebp),%eax
801045f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801045fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801045fe:	39 c3                	cmp    %eax,%ebx
80104600:	73 26                	jae    80104628 <memmove+0x38>
80104602:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104605:	39 c8                	cmp    %ecx,%eax
80104607:	73 1f                	jae    80104628 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104609:	85 f6                	test   %esi,%esi
8010460b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010460e:	74 0f                	je     8010461f <memmove+0x2f>
      *--d = *--s;
80104610:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104614:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104617:	83 ea 01             	sub    $0x1,%edx
8010461a:	83 fa ff             	cmp    $0xffffffff,%edx
8010461d:	75 f1                	jne    80104610 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010461f:	5b                   	pop    %ebx
80104620:	5e                   	pop    %esi
80104621:	5d                   	pop    %ebp
80104622:	c3                   	ret    
80104623:	90                   	nop
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104628:	31 d2                	xor    %edx,%edx
8010462a:	85 f6                	test   %esi,%esi
8010462c:	74 f1                	je     8010461f <memmove+0x2f>
8010462e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104630:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104634:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104637:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010463a:	39 d6                	cmp    %edx,%esi
8010463c:	75 f2                	jne    80104630 <memmove+0x40>
}
8010463e:	5b                   	pop    %ebx
8010463f:	5e                   	pop    %esi
80104640:	5d                   	pop    %ebp
80104641:	c3                   	ret    
80104642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104653:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104654:	eb 9a                	jmp    801045f0 <memmove>
80104656:	8d 76 00             	lea    0x0(%esi),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	56                   	push   %esi
80104665:	8b 7d 10             	mov    0x10(%ebp),%edi
80104668:	53                   	push   %ebx
80104669:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010466c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010466f:	85 ff                	test   %edi,%edi
80104671:	74 2f                	je     801046a2 <strncmp+0x42>
80104673:	0f b6 01             	movzbl (%ecx),%eax
80104676:	0f b6 1e             	movzbl (%esi),%ebx
80104679:	84 c0                	test   %al,%al
8010467b:	74 37                	je     801046b4 <strncmp+0x54>
8010467d:	38 c3                	cmp    %al,%bl
8010467f:	75 33                	jne    801046b4 <strncmp+0x54>
80104681:	01 f7                	add    %esi,%edi
80104683:	eb 13                	jmp    80104698 <strncmp+0x38>
80104685:	8d 76 00             	lea    0x0(%esi),%esi
80104688:	0f b6 01             	movzbl (%ecx),%eax
8010468b:	84 c0                	test   %al,%al
8010468d:	74 21                	je     801046b0 <strncmp+0x50>
8010468f:	0f b6 1a             	movzbl (%edx),%ebx
80104692:	89 d6                	mov    %edx,%esi
80104694:	38 d8                	cmp    %bl,%al
80104696:	75 1c                	jne    801046b4 <strncmp+0x54>
    n--, p++, q++;
80104698:	8d 56 01             	lea    0x1(%esi),%edx
8010469b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010469e:	39 fa                	cmp    %edi,%edx
801046a0:	75 e6                	jne    80104688 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801046a2:	5b                   	pop    %ebx
    return 0;
801046a3:	31 c0                	xor    %eax,%eax
}
801046a5:	5e                   	pop    %esi
801046a6:	5f                   	pop    %edi
801046a7:	5d                   	pop    %ebp
801046a8:	c3                   	ret    
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801046b4:	29 d8                	sub    %ebx,%eax
}
801046b6:	5b                   	pop    %ebx
801046b7:	5e                   	pop    %esi
801046b8:	5f                   	pop    %edi
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret    
801046bb:	90                   	nop
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 45 08             	mov    0x8(%ebp),%eax
801046c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801046cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801046ce:	89 c2                	mov    %eax,%edx
801046d0:	eb 19                	jmp    801046eb <strncpy+0x2b>
801046d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d8:	83 c3 01             	add    $0x1,%ebx
801046db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801046df:	83 c2 01             	add    $0x1,%edx
801046e2:	84 c9                	test   %cl,%cl
801046e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801046e7:	74 09                	je     801046f2 <strncpy+0x32>
801046e9:	89 f1                	mov    %esi,%ecx
801046eb:	85 c9                	test   %ecx,%ecx
801046ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046f0:	7f e6                	jg     801046d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801046f2:	31 c9                	xor    %ecx,%ecx
801046f4:	85 f6                	test   %esi,%esi
801046f6:	7e 17                	jle    8010470f <strncpy+0x4f>
801046f8:	90                   	nop
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104700:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104704:	89 f3                	mov    %esi,%ebx
80104706:	83 c1 01             	add    $0x1,%ecx
80104709:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010470b:	85 db                	test   %ebx,%ebx
8010470d:	7f f1                	jg     80104700 <strncpy+0x40>
  return os;
}
8010470f:	5b                   	pop    %ebx
80104710:	5e                   	pop    %esi
80104711:	5d                   	pop    %ebp
80104712:	c3                   	ret    
80104713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104728:	8b 45 08             	mov    0x8(%ebp),%eax
8010472b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010472e:	85 c9                	test   %ecx,%ecx
80104730:	7e 26                	jle    80104758 <safestrcpy+0x38>
80104732:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104736:	89 c1                	mov    %eax,%ecx
80104738:	eb 17                	jmp    80104751 <safestrcpy+0x31>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104740:	83 c2 01             	add    $0x1,%edx
80104743:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104747:	83 c1 01             	add    $0x1,%ecx
8010474a:	84 db                	test   %bl,%bl
8010474c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010474f:	74 04                	je     80104755 <safestrcpy+0x35>
80104751:	39 f2                	cmp    %esi,%edx
80104753:	75 eb                	jne    80104740 <safestrcpy+0x20>
    ;
  *s = 0;
80104755:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104758:	5b                   	pop    %ebx
80104759:	5e                   	pop    %esi
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <strlen>:

int
strlen(const char *s)
{
80104760:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104761:	31 c0                	xor    %eax,%eax
{
80104763:	89 e5                	mov    %esp,%ebp
80104765:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104768:	80 3a 00             	cmpb   $0x0,(%edx)
8010476b:	74 0c                	je     80104779 <strlen+0x19>
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
80104770:	83 c0 01             	add    $0x1,%eax
80104773:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104777:	75 f7                	jne    80104770 <strlen+0x10>
    ;
  return n;
}
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    

8010477b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010477b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010477f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104783:	55                   	push   %ebp
  pushl %ebx
80104784:	53                   	push   %ebx
  pushl %esi
80104785:	56                   	push   %esi
  pushl %edi
80104786:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104787:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104789:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010478b:	5f                   	pop    %edi
  popl %esi
8010478c:	5e                   	pop    %esi
  popl %ebx
8010478d:	5b                   	pop    %ebx
  popl %ebp
8010478e:	5d                   	pop    %ebp
  ret
8010478f:	c3                   	ret    

80104790 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
80104797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010479a:	e8 41 f0 ff ff       	call   801037e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010479f:	8b 00                	mov    (%eax),%eax
801047a1:	39 d8                	cmp    %ebx,%eax
801047a3:	76 1b                	jbe    801047c0 <fetchint+0x30>
801047a5:	8d 53 04             	lea    0x4(%ebx),%edx
801047a8:	39 d0                	cmp    %edx,%eax
801047aa:	72 14                	jb     801047c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801047ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801047af:	8b 13                	mov    (%ebx),%edx
801047b1:	89 10                	mov    %edx,(%eax)
  return 0;
801047b3:	31 c0                	xor    %eax,%eax
}
801047b5:	83 c4 04             	add    $0x4,%esp
801047b8:	5b                   	pop    %ebx
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	90                   	nop
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801047c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047c5:	eb ee                	jmp    801047b5 <fetchint+0x25>
801047c7:	89 f6                	mov    %esi,%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 04             	sub    $0x4,%esp
801047d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801047da:	e8 01 f0 ff ff       	call   801037e0 <myproc>

  if(addr >= curproc->sz)
801047df:	39 18                	cmp    %ebx,(%eax)
801047e1:	76 29                	jbe    8010480c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801047e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801047e6:	89 da                	mov    %ebx,%edx
801047e8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801047ea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801047ec:	39 c3                	cmp    %eax,%ebx
801047ee:	73 1c                	jae    8010480c <fetchstr+0x3c>
    if(*s == 0)
801047f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801047f3:	75 10                	jne    80104805 <fetchstr+0x35>
801047f5:	eb 39                	jmp    80104830 <fetchstr+0x60>
801047f7:	89 f6                	mov    %esi,%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104800:	80 3a 00             	cmpb   $0x0,(%edx)
80104803:	74 1b                	je     80104820 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104805:	83 c2 01             	add    $0x1,%edx
80104808:	39 d0                	cmp    %edx,%eax
8010480a:	77 f4                	ja     80104800 <fetchstr+0x30>
    return -1;
8010480c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104811:	83 c4 04             	add    $0x4,%esp
80104814:	5b                   	pop    %ebx
80104815:	5d                   	pop    %ebp
80104816:	c3                   	ret    
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104820:	83 c4 04             	add    $0x4,%esp
80104823:	89 d0                	mov    %edx,%eax
80104825:	29 d8                	sub    %ebx,%eax
80104827:	5b                   	pop    %ebx
80104828:	5d                   	pop    %ebp
80104829:	c3                   	ret    
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104830:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104832:	eb dd                	jmp    80104811 <fetchstr+0x41>
80104834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010483a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104840 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104845:	e8 96 ef ff ff       	call   801037e0 <myproc>
8010484a:	8b 40 18             	mov    0x18(%eax),%eax
8010484d:	8b 55 08             	mov    0x8(%ebp),%edx
80104850:	8b 40 44             	mov    0x44(%eax),%eax
80104853:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104856:	e8 85 ef ff ff       	call   801037e0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010485b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010485d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104860:	39 c6                	cmp    %eax,%esi
80104862:	73 1c                	jae    80104880 <argint+0x40>
80104864:	8d 53 08             	lea    0x8(%ebx),%edx
80104867:	39 d0                	cmp    %edx,%eax
80104869:	72 15                	jb     80104880 <argint+0x40>
  *ip = *(int*)(addr);
8010486b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486e:	8b 53 04             	mov    0x4(%ebx),%edx
80104871:	89 10                	mov    %edx,(%eax)
  return 0;
80104873:	31 c0                	xor    %eax,%eax
}
80104875:	5b                   	pop    %ebx
80104876:	5e                   	pop    %esi
80104877:	5d                   	pop    %ebp
80104878:	c3                   	ret    
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104885:	eb ee                	jmp    80104875 <argint+0x35>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	83 ec 10             	sub    $0x10,%esp
80104898:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010489b:	e8 40 ef ff ff       	call   801037e0 <myproc>
801048a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801048a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048a5:	83 ec 08             	sub    $0x8,%esp
801048a8:	50                   	push   %eax
801048a9:	ff 75 08             	pushl  0x8(%ebp)
801048ac:	e8 8f ff ff ff       	call   80104840 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801048b1:	83 c4 10             	add    $0x10,%esp
801048b4:	85 c0                	test   %eax,%eax
801048b6:	78 28                	js     801048e0 <argptr+0x50>
801048b8:	85 db                	test   %ebx,%ebx
801048ba:	78 24                	js     801048e0 <argptr+0x50>
801048bc:	8b 16                	mov    (%esi),%edx
801048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c1:	39 c2                	cmp    %eax,%edx
801048c3:	76 1b                	jbe    801048e0 <argptr+0x50>
801048c5:	01 c3                	add    %eax,%ebx
801048c7:	39 da                	cmp    %ebx,%edx
801048c9:	72 15                	jb     801048e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801048ce:	89 02                	mov    %eax,(%edx)
  return 0;
801048d0:	31 c0                	xor    %eax,%eax
}
801048d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d5:	5b                   	pop    %ebx
801048d6:	5e                   	pop    %esi
801048d7:	5d                   	pop    %ebp
801048d8:	c3                   	ret    
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e5:	eb eb                	jmp    801048d2 <argptr+0x42>
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801048f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048f9:	50                   	push   %eax
801048fa:	ff 75 08             	pushl  0x8(%ebp)
801048fd:	e8 3e ff ff ff       	call   80104840 <argint>
80104902:	83 c4 10             	add    $0x10,%esp
80104905:	85 c0                	test   %eax,%eax
80104907:	78 17                	js     80104920 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104909:	83 ec 08             	sub    $0x8,%esp
8010490c:	ff 75 0c             	pushl  0xc(%ebp)
8010490f:	ff 75 f4             	pushl  -0xc(%ebp)
80104912:	e8 b9 fe ff ff       	call   801047d0 <fetchstr>
80104917:	83 c4 10             	add    $0x10,%esp
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104925:	c9                   	leave  
80104926:	c3                   	ret    
80104927:	89 f6                	mov    %esi,%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <syscall>:
[SYS_cps]   sys_cps,   //add the cps to list of system call
};

void
syscall(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104937:	e8 a4 ee ff ff       	call   801037e0 <myproc>
8010493c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010493e:	8b 40 18             	mov    0x18(%eax),%eax
80104941:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104944:	8d 50 ff             	lea    -0x1(%eax),%edx
80104947:	83 fa 15             	cmp    $0x15,%edx
8010494a:	77 1c                	ja     80104968 <syscall+0x38>
8010494c:	8b 14 85 00 77 10 80 	mov    -0x7fef8900(,%eax,4),%edx
80104953:	85 d2                	test   %edx,%edx
80104955:	74 11                	je     80104968 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104957:	ff d2                	call   *%edx
80104959:	8b 53 18             	mov    0x18(%ebx),%edx
8010495c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010495f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104962:	c9                   	leave  
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104968:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104969:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010496c:	50                   	push   %eax
8010496d:	ff 73 10             	pushl  0x10(%ebx)
80104970:	68 d1 76 10 80       	push   $0x801076d1
80104975:	e8 e6 bc ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010497a:	8b 43 18             	mov    0x18(%ebx),%eax
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax

80104990 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104996:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104999:	83 ec 34             	sub    $0x34,%esp
8010499c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010499f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801049a2:	56                   	push   %esi
801049a3:	50                   	push   %eax
{
801049a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801049aa:	e8 51 d5 ff ff       	call   80101f00 <nameiparent>
801049af:	83 c4 10             	add    $0x10,%esp
801049b2:	85 c0                	test   %eax,%eax
801049b4:	0f 84 46 01 00 00    	je     80104b00 <create+0x170>
    return 0;
  ilock(dp);
801049ba:	83 ec 0c             	sub    $0xc,%esp
801049bd:	89 c3                	mov    %eax,%ebx
801049bf:	50                   	push   %eax
801049c0:	e8 bb cc ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801049c5:	83 c4 0c             	add    $0xc,%esp
801049c8:	6a 00                	push   $0x0
801049ca:	56                   	push   %esi
801049cb:	53                   	push   %ebx
801049cc:	e8 df d1 ff ff       	call   80101bb0 <dirlookup>
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	85 c0                	test   %eax,%eax
801049d6:	89 c7                	mov    %eax,%edi
801049d8:	74 36                	je     80104a10 <create+0x80>
    iunlockput(dp);
801049da:	83 ec 0c             	sub    $0xc,%esp
801049dd:	53                   	push   %ebx
801049de:	e8 2d cf ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801049e3:	89 3c 24             	mov    %edi,(%esp)
801049e6:	e8 95 cc ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049eb:	83 c4 10             	add    $0x10,%esp
801049ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801049f3:	0f 85 97 00 00 00    	jne    80104a90 <create+0x100>
801049f9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801049fe:	0f 85 8c 00 00 00    	jne    80104a90 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a07:	89 f8                	mov    %edi,%eax
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5f                   	pop    %edi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104a10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104a14:	83 ec 08             	sub    $0x8,%esp
80104a17:	50                   	push   %eax
80104a18:	ff 33                	pushl  (%ebx)
80104a1a:	e8 f1 ca ff ff       	call   80101510 <ialloc>
80104a1f:	83 c4 10             	add    $0x10,%esp
80104a22:	85 c0                	test   %eax,%eax
80104a24:	89 c7                	mov    %eax,%edi
80104a26:	0f 84 e8 00 00 00    	je     80104b14 <create+0x184>
  ilock(ip);
80104a2c:	83 ec 0c             	sub    $0xc,%esp
80104a2f:	50                   	push   %eax
80104a30:	e8 4b cc ff ff       	call   80101680 <ilock>
  ip->major = major;
80104a35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104a39:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104a3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104a41:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104a45:	b8 01 00 00 00       	mov    $0x1,%eax
80104a4a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104a4e:	89 3c 24             	mov    %edi,(%esp)
80104a51:	e8 7a cb ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104a56:	83 c4 10             	add    $0x10,%esp
80104a59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104a5e:	74 50                	je     80104ab0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104a60:	83 ec 04             	sub    $0x4,%esp
80104a63:	ff 77 04             	pushl  0x4(%edi)
80104a66:	56                   	push   %esi
80104a67:	53                   	push   %ebx
80104a68:	e8 b3 d3 ff ff       	call   80101e20 <dirlink>
80104a6d:	83 c4 10             	add    $0x10,%esp
80104a70:	85 c0                	test   %eax,%eax
80104a72:	0f 88 8f 00 00 00    	js     80104b07 <create+0x177>
  iunlockput(dp);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	53                   	push   %ebx
80104a7c:	e8 8f ce ff ff       	call   80101910 <iunlockput>
  return ip;
80104a81:	83 c4 10             	add    $0x10,%esp
}
80104a84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a87:	89 f8                	mov    %edi,%eax
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5f                   	pop    %edi
80104a8c:	5d                   	pop    %ebp
80104a8d:	c3                   	ret    
80104a8e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104a90:	83 ec 0c             	sub    $0xc,%esp
80104a93:	57                   	push   %edi
    return 0;
80104a94:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a96:	e8 75 ce ff ff       	call   80101910 <iunlockput>
    return 0;
80104a9b:	83 c4 10             	add    $0x10,%esp
}
80104a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa1:	89 f8                	mov    %edi,%eax
80104aa3:	5b                   	pop    %ebx
80104aa4:	5e                   	pop    %esi
80104aa5:	5f                   	pop    %edi
80104aa6:	5d                   	pop    %ebp
80104aa7:	c3                   	ret    
80104aa8:	90                   	nop
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104ab0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ab5:	83 ec 0c             	sub    $0xc,%esp
80104ab8:	53                   	push   %ebx
80104ab9:	e8 12 cb ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104abe:	83 c4 0c             	add    $0xc,%esp
80104ac1:	ff 77 04             	pushl  0x4(%edi)
80104ac4:	68 78 77 10 80       	push   $0x80107778
80104ac9:	57                   	push   %edi
80104aca:	e8 51 d3 ff ff       	call   80101e20 <dirlink>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	78 1c                	js     80104af2 <create+0x162>
80104ad6:	83 ec 04             	sub    $0x4,%esp
80104ad9:	ff 73 04             	pushl  0x4(%ebx)
80104adc:	68 77 77 10 80       	push   $0x80107777
80104ae1:	57                   	push   %edi
80104ae2:	e8 39 d3 ff ff       	call   80101e20 <dirlink>
80104ae7:	83 c4 10             	add    $0x10,%esp
80104aea:	85 c0                	test   %eax,%eax
80104aec:	0f 89 6e ff ff ff    	jns    80104a60 <create+0xd0>
      panic("create dots");
80104af2:	83 ec 0c             	sub    $0xc,%esp
80104af5:	68 6b 77 10 80       	push   $0x8010776b
80104afa:	e8 91 b8 ff ff       	call   80100390 <panic>
80104aff:	90                   	nop
    return 0;
80104b00:	31 ff                	xor    %edi,%edi
80104b02:	e9 fd fe ff ff       	jmp    80104a04 <create+0x74>
    panic("create: dirlink");
80104b07:	83 ec 0c             	sub    $0xc,%esp
80104b0a:	68 7a 77 10 80       	push   $0x8010777a
80104b0f:	e8 7c b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	68 5c 77 10 80       	push   $0x8010775c
80104b1c:	e8 6f b8 ff ff       	call   80100390 <panic>
80104b21:	eb 0d                	jmp    80104b30 <argfd.constprop.0>
80104b23:	90                   	nop
80104b24:	90                   	nop
80104b25:	90                   	nop
80104b26:	90                   	nop
80104b27:	90                   	nop
80104b28:	90                   	nop
80104b29:	90                   	nop
80104b2a:	90                   	nop
80104b2b:	90                   	nop
80104b2c:	90                   	nop
80104b2d:	90                   	nop
80104b2e:	90                   	nop
80104b2f:	90                   	nop

80104b30 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
80104b35:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104b3a:	89 d6                	mov    %edx,%esi
80104b3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b3f:	50                   	push   %eax
80104b40:	6a 00                	push   $0x0
80104b42:	e8 f9 fc ff ff       	call   80104840 <argint>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	78 2a                	js     80104b78 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b52:	77 24                	ja     80104b78 <argfd.constprop.0+0x48>
80104b54:	e8 87 ec ff ff       	call   801037e0 <myproc>
80104b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104b60:	85 c0                	test   %eax,%eax
80104b62:	74 14                	je     80104b78 <argfd.constprop.0+0x48>
  if(pfd)
80104b64:	85 db                	test   %ebx,%ebx
80104b66:	74 02                	je     80104b6a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104b68:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104b6a:	89 06                	mov    %eax,(%esi)
  return 0;
80104b6c:	31 c0                	xor    %eax,%eax
}
80104b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5d                   	pop    %ebp
80104b74:	c3                   	ret    
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b7d:	eb ef                	jmp    80104b6e <argfd.constprop.0+0x3e>
80104b7f:	90                   	nop

80104b80 <sys_dup>:
{
80104b80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104b81:	31 c0                	xor    %eax,%eax
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	56                   	push   %esi
80104b86:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104b87:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104b8a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104b8d:	e8 9e ff ff ff       	call   80104b30 <argfd.constprop.0>
80104b92:	85 c0                	test   %eax,%eax
80104b94:	78 42                	js     80104bd8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104b96:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b99:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104b9b:	e8 40 ec ff ff       	call   801037e0 <myproc>
80104ba0:	eb 0e                	jmp    80104bb0 <sys_dup+0x30>
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ba8:	83 c3 01             	add    $0x1,%ebx
80104bab:	83 fb 10             	cmp    $0x10,%ebx
80104bae:	74 28                	je     80104bd8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104bb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104bb4:	85 d2                	test   %edx,%edx
80104bb6:	75 f0                	jne    80104ba8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104bb8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104bc2:	e8 29 c2 ff ff       	call   80100df0 <filedup>
  return fd;
80104bc7:	83 c4 10             	add    $0x10,%esp
}
80104bca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bcd:	89 d8                	mov    %ebx,%eax
80104bcf:	5b                   	pop    %ebx
80104bd0:	5e                   	pop    %esi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104bdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104be0:	89 d8                	mov    %ebx,%eax
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
80104be5:	c3                   	ret    
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <sys_read>:
{
80104bf0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bf1:	31 c0                	xor    %eax,%eax
{
80104bf3:	89 e5                	mov    %esp,%ebp
80104bf5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bfb:	e8 30 ff ff ff       	call   80104b30 <argfd.constprop.0>
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 4c                	js     80104c50 <sys_read+0x60>
80104c04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c07:	83 ec 08             	sub    $0x8,%esp
80104c0a:	50                   	push   %eax
80104c0b:	6a 02                	push   $0x2
80104c0d:	e8 2e fc ff ff       	call   80104840 <argint>
80104c12:	83 c4 10             	add    $0x10,%esp
80104c15:	85 c0                	test   %eax,%eax
80104c17:	78 37                	js     80104c50 <sys_read+0x60>
80104c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c1c:	83 ec 04             	sub    $0x4,%esp
80104c1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c22:	50                   	push   %eax
80104c23:	6a 01                	push   $0x1
80104c25:	e8 66 fc ff ff       	call   80104890 <argptr>
80104c2a:	83 c4 10             	add    $0x10,%esp
80104c2d:	85 c0                	test   %eax,%eax
80104c2f:	78 1f                	js     80104c50 <sys_read+0x60>
  return fileread(f, p, n);
80104c31:	83 ec 04             	sub    $0x4,%esp
80104c34:	ff 75 f0             	pushl  -0x10(%ebp)
80104c37:	ff 75 f4             	pushl  -0xc(%ebp)
80104c3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c3d:	e8 1e c3 ff ff       	call   80100f60 <fileread>
80104c42:	83 c4 10             	add    $0x10,%esp
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <sys_write>:
{
80104c60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c61:	31 c0                	xor    %eax,%eax
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c6b:	e8 c0 fe ff ff       	call   80104b30 <argfd.constprop.0>
80104c70:	85 c0                	test   %eax,%eax
80104c72:	78 4c                	js     80104cc0 <sys_write+0x60>
80104c74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c77:	83 ec 08             	sub    $0x8,%esp
80104c7a:	50                   	push   %eax
80104c7b:	6a 02                	push   $0x2
80104c7d:	e8 be fb ff ff       	call   80104840 <argint>
80104c82:	83 c4 10             	add    $0x10,%esp
80104c85:	85 c0                	test   %eax,%eax
80104c87:	78 37                	js     80104cc0 <sys_write+0x60>
80104c89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c8c:	83 ec 04             	sub    $0x4,%esp
80104c8f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c92:	50                   	push   %eax
80104c93:	6a 01                	push   $0x1
80104c95:	e8 f6 fb ff ff       	call   80104890 <argptr>
80104c9a:	83 c4 10             	add    $0x10,%esp
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	78 1f                	js     80104cc0 <sys_write+0x60>
  return filewrite(f, p, n);
80104ca1:	83 ec 04             	sub    $0x4,%esp
80104ca4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ca7:	ff 75 f4             	pushl  -0xc(%ebp)
80104caa:	ff 75 ec             	pushl  -0x14(%ebp)
80104cad:	e8 3e c3 ff ff       	call   80100ff0 <filewrite>
80104cb2:	83 c4 10             	add    $0x10,%esp
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_close>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104cd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104cd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cdc:	e8 4f fe ff ff       	call   80104b30 <argfd.constprop.0>
80104ce1:	85 c0                	test   %eax,%eax
80104ce3:	78 2b                	js     80104d10 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ce5:	e8 f6 ea ff ff       	call   801037e0 <myproc>
80104cea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104ced:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104cf0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104cf7:	00 
  fileclose(f);
80104cf8:	ff 75 f4             	pushl  -0xc(%ebp)
80104cfb:	e8 40 c1 ff ff       	call   80100e40 <fileclose>
  return 0;
80104d00:	83 c4 10             	add    $0x10,%esp
80104d03:	31 c0                	xor    %eax,%eax
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <sys_fstat>:
{
80104d20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d21:	31 c0                	xor    %eax,%eax
{
80104d23:	89 e5                	mov    %esp,%ebp
80104d25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d28:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d2b:	e8 00 fe ff ff       	call   80104b30 <argfd.constprop.0>
80104d30:	85 c0                	test   %eax,%eax
80104d32:	78 2c                	js     80104d60 <sys_fstat+0x40>
80104d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d37:	83 ec 04             	sub    $0x4,%esp
80104d3a:	6a 14                	push   $0x14
80104d3c:	50                   	push   %eax
80104d3d:	6a 01                	push   $0x1
80104d3f:	e8 4c fb ff ff       	call   80104890 <argptr>
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	85 c0                	test   %eax,%eax
80104d49:	78 15                	js     80104d60 <sys_fstat+0x40>
  return filestat(f, st);
80104d4b:	83 ec 08             	sub    $0x8,%esp
80104d4e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d51:	ff 75 f0             	pushl  -0x10(%ebp)
80104d54:	e8 b7 c1 ff ff       	call   80100f10 <filestat>
80104d59:	83 c4 10             	add    $0x10,%esp
}
80104d5c:	c9                   	leave  
80104d5d:	c3                   	ret    
80104d5e:	66 90                	xchg   %ax,%ax
    return -1;
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <sys_link>:
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d76:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104d79:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d7c:	50                   	push   %eax
80104d7d:	6a 00                	push   $0x0
80104d7f:	e8 6c fb ff ff       	call   801048f0 <argstr>
80104d84:	83 c4 10             	add    $0x10,%esp
80104d87:	85 c0                	test   %eax,%eax
80104d89:	0f 88 fb 00 00 00    	js     80104e8a <sys_link+0x11a>
80104d8f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d92:	83 ec 08             	sub    $0x8,%esp
80104d95:	50                   	push   %eax
80104d96:	6a 01                	push   $0x1
80104d98:	e8 53 fb ff ff       	call   801048f0 <argstr>
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	85 c0                	test   %eax,%eax
80104da2:	0f 88 e2 00 00 00    	js     80104e8a <sys_link+0x11a>
  begin_op();
80104da8:	e8 f3 dd ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80104dad:	83 ec 0c             	sub    $0xc,%esp
80104db0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104db3:	e8 28 d1 ff ff       	call   80101ee0 <namei>
80104db8:	83 c4 10             	add    $0x10,%esp
80104dbb:	85 c0                	test   %eax,%eax
80104dbd:	89 c3                	mov    %eax,%ebx
80104dbf:	0f 84 ea 00 00 00    	je     80104eaf <sys_link+0x13f>
  ilock(ip);
80104dc5:	83 ec 0c             	sub    $0xc,%esp
80104dc8:	50                   	push   %eax
80104dc9:	e8 b2 c8 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80104dce:	83 c4 10             	add    $0x10,%esp
80104dd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dd6:	0f 84 bb 00 00 00    	je     80104e97 <sys_link+0x127>
  ip->nlink++;
80104ddc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104de1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104de4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104de7:	53                   	push   %ebx
80104de8:	e8 e3 c7 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80104ded:	89 1c 24             	mov    %ebx,(%esp)
80104df0:	e8 6b c9 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104df5:	58                   	pop    %eax
80104df6:	5a                   	pop    %edx
80104df7:	57                   	push   %edi
80104df8:	ff 75 d0             	pushl  -0x30(%ebp)
80104dfb:	e8 00 d1 ff ff       	call   80101f00 <nameiparent>
80104e00:	83 c4 10             	add    $0x10,%esp
80104e03:	85 c0                	test   %eax,%eax
80104e05:	89 c6                	mov    %eax,%esi
80104e07:	74 5b                	je     80104e64 <sys_link+0xf4>
  ilock(dp);
80104e09:	83 ec 0c             	sub    $0xc,%esp
80104e0c:	50                   	push   %eax
80104e0d:	e8 6e c8 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e12:	83 c4 10             	add    $0x10,%esp
80104e15:	8b 03                	mov    (%ebx),%eax
80104e17:	39 06                	cmp    %eax,(%esi)
80104e19:	75 3d                	jne    80104e58 <sys_link+0xe8>
80104e1b:	83 ec 04             	sub    $0x4,%esp
80104e1e:	ff 73 04             	pushl  0x4(%ebx)
80104e21:	57                   	push   %edi
80104e22:	56                   	push   %esi
80104e23:	e8 f8 cf ff ff       	call   80101e20 <dirlink>
80104e28:	83 c4 10             	add    $0x10,%esp
80104e2b:	85 c0                	test   %eax,%eax
80104e2d:	78 29                	js     80104e58 <sys_link+0xe8>
  iunlockput(dp);
80104e2f:	83 ec 0c             	sub    $0xc,%esp
80104e32:	56                   	push   %esi
80104e33:	e8 d8 ca ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104e38:	89 1c 24             	mov    %ebx,(%esp)
80104e3b:	e8 70 c9 ff ff       	call   801017b0 <iput>
  end_op();
80104e40:	e8 cb dd ff ff       	call   80102c10 <end_op>
  return 0;
80104e45:	83 c4 10             	add    $0x10,%esp
80104e48:	31 c0                	xor    %eax,%eax
}
80104e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e4d:	5b                   	pop    %ebx
80104e4e:	5e                   	pop    %esi
80104e4f:	5f                   	pop    %edi
80104e50:	5d                   	pop    %ebp
80104e51:	c3                   	ret    
80104e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104e58:	83 ec 0c             	sub    $0xc,%esp
80104e5b:	56                   	push   %esi
80104e5c:	e8 af ca ff ff       	call   80101910 <iunlockput>
    goto bad;
80104e61:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104e64:	83 ec 0c             	sub    $0xc,%esp
80104e67:	53                   	push   %ebx
80104e68:	e8 13 c8 ff ff       	call   80101680 <ilock>
  ip->nlink--;
80104e6d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e72:	89 1c 24             	mov    %ebx,(%esp)
80104e75:	e8 56 c7 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104e7a:	89 1c 24             	mov    %ebx,(%esp)
80104e7d:	e8 8e ca ff ff       	call   80101910 <iunlockput>
  end_op();
80104e82:	e8 89 dd ff ff       	call   80102c10 <end_op>
  return -1;
80104e87:	83 c4 10             	add    $0x10,%esp
}
80104e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e92:	5b                   	pop    %ebx
80104e93:	5e                   	pop    %esi
80104e94:	5f                   	pop    %edi
80104e95:	5d                   	pop    %ebp
80104e96:	c3                   	ret    
    iunlockput(ip);
80104e97:	83 ec 0c             	sub    $0xc,%esp
80104e9a:	53                   	push   %ebx
80104e9b:	e8 70 ca ff ff       	call   80101910 <iunlockput>
    end_op();
80104ea0:	e8 6b dd ff ff       	call   80102c10 <end_op>
    return -1;
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ead:	eb 9b                	jmp    80104e4a <sys_link+0xda>
    end_op();
80104eaf:	e8 5c dd ff ff       	call   80102c10 <end_op>
    return -1;
80104eb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb9:	eb 8f                	jmp    80104e4a <sys_link+0xda>
80104ebb:	90                   	nop
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <sys_unlink>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104ec6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104ec9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104ecc:	50                   	push   %eax
80104ecd:	6a 00                	push   $0x0
80104ecf:	e8 1c fa ff ff       	call   801048f0 <argstr>
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	0f 88 77 01 00 00    	js     80105056 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104edf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104ee2:	e8 b9 dc ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ee7:	83 ec 08             	sub    $0x8,%esp
80104eea:	53                   	push   %ebx
80104eeb:	ff 75 c0             	pushl  -0x40(%ebp)
80104eee:	e8 0d d0 ff ff       	call   80101f00 <nameiparent>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	89 c6                	mov    %eax,%esi
80104efa:	0f 84 60 01 00 00    	je     80105060 <sys_unlink+0x1a0>
  ilock(dp);
80104f00:	83 ec 0c             	sub    $0xc,%esp
80104f03:	50                   	push   %eax
80104f04:	e8 77 c7 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f09:	58                   	pop    %eax
80104f0a:	5a                   	pop    %edx
80104f0b:	68 78 77 10 80       	push   $0x80107778
80104f10:	53                   	push   %ebx
80104f11:	e8 7a cc ff ff       	call   80101b90 <namecmp>
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	85 c0                	test   %eax,%eax
80104f1b:	0f 84 03 01 00 00    	je     80105024 <sys_unlink+0x164>
80104f21:	83 ec 08             	sub    $0x8,%esp
80104f24:	68 77 77 10 80       	push   $0x80107777
80104f29:	53                   	push   %ebx
80104f2a:	e8 61 cc ff ff       	call   80101b90 <namecmp>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	0f 84 ea 00 00 00    	je     80105024 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f3a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f3d:	83 ec 04             	sub    $0x4,%esp
80104f40:	50                   	push   %eax
80104f41:	53                   	push   %ebx
80104f42:	56                   	push   %esi
80104f43:	e8 68 cc ff ff       	call   80101bb0 <dirlookup>
80104f48:	83 c4 10             	add    $0x10,%esp
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	89 c3                	mov    %eax,%ebx
80104f4f:	0f 84 cf 00 00 00    	je     80105024 <sys_unlink+0x164>
  ilock(ip);
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	50                   	push   %eax
80104f59:	e8 22 c7 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f66:	0f 8e 10 01 00 00    	jle    8010507c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f71:	74 6d                	je     80104fe0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104f73:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f76:	83 ec 04             	sub    $0x4,%esp
80104f79:	6a 10                	push   $0x10
80104f7b:	6a 00                	push   $0x0
80104f7d:	50                   	push   %eax
80104f7e:	e8 bd f5 ff ff       	call   80104540 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f83:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f86:	6a 10                	push   $0x10
80104f88:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f8b:	50                   	push   %eax
80104f8c:	56                   	push   %esi
80104f8d:	e8 ce ca ff ff       	call   80101a60 <writei>
80104f92:	83 c4 20             	add    $0x20,%esp
80104f95:	83 f8 10             	cmp    $0x10,%eax
80104f98:	0f 85 eb 00 00 00    	jne    80105089 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104f9e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fa3:	0f 84 97 00 00 00    	je     80105040 <sys_unlink+0x180>
  iunlockput(dp);
80104fa9:	83 ec 0c             	sub    $0xc,%esp
80104fac:	56                   	push   %esi
80104fad:	e8 5e c9 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80104fb2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fb7:	89 1c 24             	mov    %ebx,(%esp)
80104fba:	e8 11 c6 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104fbf:	89 1c 24             	mov    %ebx,(%esp)
80104fc2:	e8 49 c9 ff ff       	call   80101910 <iunlockput>
  end_op();
80104fc7:	e8 44 dc ff ff       	call   80102c10 <end_op>
  return 0;
80104fcc:	83 c4 10             	add    $0x10,%esp
80104fcf:	31 c0                	xor    %eax,%eax
}
80104fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd4:	5b                   	pop    %ebx
80104fd5:	5e                   	pop    %esi
80104fd6:	5f                   	pop    %edi
80104fd7:	5d                   	pop    %ebp
80104fd8:	c3                   	ret    
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fe0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fe4:	76 8d                	jbe    80104f73 <sys_unlink+0xb3>
80104fe6:	bf 20 00 00 00       	mov    $0x20,%edi
80104feb:	eb 0f                	jmp    80104ffc <sys_unlink+0x13c>
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
80104ff0:	83 c7 10             	add    $0x10,%edi
80104ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104ff6:	0f 83 77 ff ff ff    	jae    80104f73 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ffc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104fff:	6a 10                	push   $0x10
80105001:	57                   	push   %edi
80105002:	50                   	push   %eax
80105003:	53                   	push   %ebx
80105004:	e8 57 c9 ff ff       	call   80101960 <readi>
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	83 f8 10             	cmp    $0x10,%eax
8010500f:	75 5e                	jne    8010506f <sys_unlink+0x1af>
    if(de.inum != 0)
80105011:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105016:	74 d8                	je     80104ff0 <sys_unlink+0x130>
    iunlockput(ip);
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	53                   	push   %ebx
8010501c:	e8 ef c8 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105021:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	56                   	push   %esi
80105028:	e8 e3 c8 ff ff       	call   80101910 <iunlockput>
  end_op();
8010502d:	e8 de db ff ff       	call   80102c10 <end_op>
  return -1;
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503a:	eb 95                	jmp    80104fd1 <sys_unlink+0x111>
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105040:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	56                   	push   %esi
80105049:	e8 82 c5 ff ff       	call   801015d0 <iupdate>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	e9 53 ff ff ff       	jmp    80104fa9 <sys_unlink+0xe9>
    return -1;
80105056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505b:	e9 71 ff ff ff       	jmp    80104fd1 <sys_unlink+0x111>
    end_op();
80105060:	e8 ab db ff ff       	call   80102c10 <end_op>
    return -1;
80105065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506a:	e9 62 ff ff ff       	jmp    80104fd1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	68 9c 77 10 80       	push   $0x8010779c
80105077:	e8 14 b3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010507c:	83 ec 0c             	sub    $0xc,%esp
8010507f:	68 8a 77 10 80       	push   $0x8010778a
80105084:	e8 07 b3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	68 ae 77 10 80       	push   $0x801077ae
80105091:	e8 fa b2 ff ff       	call   80100390 <panic>
80105096:	8d 76 00             	lea    0x0(%esi),%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_open>:

int
sys_open(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801050a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 3c f8 ff ff       	call   801048f0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 1d 01 00 00    	js     801051dc <sys_open+0x13c>
801050bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050c2:	83 ec 08             	sub    $0x8,%esp
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 73 f7 ff ff       	call   80104840 <argint>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	0f 88 04 01 00 00    	js     801051dc <sys_open+0x13c>
    return -1;

  begin_op();
801050d8:	e8 c3 da ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
801050dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050e1:	0f 85 a9 00 00 00    	jne    80105190 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	ff 75 e0             	pushl  -0x20(%ebp)
801050ed:	e8 ee cd ff ff       	call   80101ee0 <namei>
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	85 c0                	test   %eax,%eax
801050f7:	89 c6                	mov    %eax,%esi
801050f9:	0f 84 b2 00 00 00    	je     801051b1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801050ff:	83 ec 0c             	sub    $0xc,%esp
80105102:	50                   	push   %eax
80105103:	e8 78 c5 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105110:	0f 84 aa 00 00 00    	je     801051c0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105116:	e8 65 bc ff ff       	call   80100d80 <filealloc>
8010511b:	85 c0                	test   %eax,%eax
8010511d:	89 c7                	mov    %eax,%edi
8010511f:	0f 84 a6 00 00 00    	je     801051cb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105125:	e8 b6 e6 ff ff       	call   801037e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010512a:	31 db                	xor    %ebx,%ebx
8010512c:	eb 0e                	jmp    8010513c <sys_open+0x9c>
8010512e:	66 90                	xchg   %ax,%ax
80105130:	83 c3 01             	add    $0x1,%ebx
80105133:	83 fb 10             	cmp    $0x10,%ebx
80105136:	0f 84 ac 00 00 00    	je     801051e8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010513c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105140:	85 d2                	test   %edx,%edx
80105142:	75 ec                	jne    80105130 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105144:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105147:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010514b:	56                   	push   %esi
8010514c:	e8 0f c6 ff ff       	call   80101760 <iunlock>
  end_op();
80105151:	e8 ba da ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105156:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010515c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010515f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105162:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105165:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010516c:	89 d0                	mov    %edx,%eax
8010516e:	f7 d0                	not    %eax
80105170:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105173:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105176:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105179:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010517d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105180:	89 d8                	mov    %ebx,%eax
80105182:	5b                   	pop    %ebx
80105183:	5e                   	pop    %esi
80105184:	5f                   	pop    %edi
80105185:	5d                   	pop    %ebp
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105196:	31 c9                	xor    %ecx,%ecx
80105198:	6a 00                	push   $0x0
8010519a:	ba 02 00 00 00       	mov    $0x2,%edx
8010519f:	e8 ec f7 ff ff       	call   80104990 <create>
    if(ip == 0){
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801051a9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801051ab:	0f 85 65 ff ff ff    	jne    80105116 <sys_open+0x76>
      end_op();
801051b1:	e8 5a da ff ff       	call   80102c10 <end_op>
      return -1;
801051b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051bb:	eb c0                	jmp    8010517d <sys_open+0xdd>
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801051c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051c3:	85 c9                	test   %ecx,%ecx
801051c5:	0f 84 4b ff ff ff    	je     80105116 <sys_open+0x76>
    iunlockput(ip);
801051cb:	83 ec 0c             	sub    $0xc,%esp
801051ce:	56                   	push   %esi
801051cf:	e8 3c c7 ff ff       	call   80101910 <iunlockput>
    end_op();
801051d4:	e8 37 da ff ff       	call   80102c10 <end_op>
    return -1;
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051e1:	eb 9a                	jmp    8010517d <sys_open+0xdd>
801051e3:	90                   	nop
801051e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	57                   	push   %edi
801051ec:	e8 4f bc ff ff       	call   80100e40 <fileclose>
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	eb d5                	jmp    801051cb <sys_open+0x12b>
801051f6:	8d 76 00             	lea    0x0(%esi),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_mkdir>:

int
sys_mkdir(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105206:	e8 95 d9 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010520b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520e:	83 ec 08             	sub    $0x8,%esp
80105211:	50                   	push   %eax
80105212:	6a 00                	push   $0x0
80105214:	e8 d7 f6 ff ff       	call   801048f0 <argstr>
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	85 c0                	test   %eax,%eax
8010521e:	78 30                	js     80105250 <sys_mkdir+0x50>
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105226:	31 c9                	xor    %ecx,%ecx
80105228:	6a 00                	push   $0x0
8010522a:	ba 01 00 00 00       	mov    $0x1,%edx
8010522f:	e8 5c f7 ff ff       	call   80104990 <create>
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
80105239:	74 15                	je     80105250 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010523b:	83 ec 0c             	sub    $0xc,%esp
8010523e:	50                   	push   %eax
8010523f:	e8 cc c6 ff ff       	call   80101910 <iunlockput>
  end_op();
80105244:	e8 c7 d9 ff ff       	call   80102c10 <end_op>
  return 0;
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	31 c0                	xor    %eax,%eax
}
8010524e:	c9                   	leave  
8010524f:	c3                   	ret    
    end_op();
80105250:	e8 bb d9 ff ff       	call   80102c10 <end_op>
    return -1;
80105255:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010525a:	c9                   	leave  
8010525b:	c3                   	ret    
8010525c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_mknod>:

int
sys_mknod(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105266:	e8 35 d9 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010526b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010526e:	83 ec 08             	sub    $0x8,%esp
80105271:	50                   	push   %eax
80105272:	6a 00                	push   $0x0
80105274:	e8 77 f6 ff ff       	call   801048f0 <argstr>
80105279:	83 c4 10             	add    $0x10,%esp
8010527c:	85 c0                	test   %eax,%eax
8010527e:	78 60                	js     801052e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105280:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105283:	83 ec 08             	sub    $0x8,%esp
80105286:	50                   	push   %eax
80105287:	6a 01                	push   $0x1
80105289:	e8 b2 f5 ff ff       	call   80104840 <argint>
  if((argstr(0, &path)) < 0 ||
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	85 c0                	test   %eax,%eax
80105293:	78 4b                	js     801052e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105295:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105298:	83 ec 08             	sub    $0x8,%esp
8010529b:	50                   	push   %eax
8010529c:	6a 02                	push   $0x2
8010529e:	e8 9d f5 ff ff       	call   80104840 <argint>
     argint(1, &major) < 0 ||
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	78 36                	js     801052e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801052aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801052ae:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801052b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801052b5:	ba 03 00 00 00       	mov    $0x3,%edx
801052ba:	50                   	push   %eax
801052bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052be:	e8 cd f6 ff ff       	call   80104990 <create>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	74 16                	je     801052e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ca:	83 ec 0c             	sub    $0xc,%esp
801052cd:	50                   	push   %eax
801052ce:	e8 3d c6 ff ff       	call   80101910 <iunlockput>
  end_op();
801052d3:	e8 38 d9 ff ff       	call   80102c10 <end_op>
  return 0;
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	31 c0                	xor    %eax,%eax
}
801052dd:	c9                   	leave  
801052de:	c3                   	ret    
801052df:	90                   	nop
    end_op();
801052e0:	e8 2b d9 ff ff       	call   80102c10 <end_op>
    return -1;
801052e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_chdir>:

int
sys_chdir(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052f8:	e8 e3 e4 ff ff       	call   801037e0 <myproc>
801052fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052ff:	e8 9c d8 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105304:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105307:	83 ec 08             	sub    $0x8,%esp
8010530a:	50                   	push   %eax
8010530b:	6a 00                	push   $0x0
8010530d:	e8 de f5 ff ff       	call   801048f0 <argstr>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	78 77                	js     80105390 <sys_chdir+0xa0>
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	ff 75 f4             	pushl  -0xc(%ebp)
8010531f:	e8 bc cb ff ff       	call   80101ee0 <namei>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	89 c3                	mov    %eax,%ebx
8010532b:	74 63                	je     80105390 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010532d:	83 ec 0c             	sub    $0xc,%esp
80105330:	50                   	push   %eax
80105331:	e8 4a c3 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105336:	83 c4 10             	add    $0x10,%esp
80105339:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010533e:	75 30                	jne    80105370 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	53                   	push   %ebx
80105344:	e8 17 c4 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105349:	58                   	pop    %eax
8010534a:	ff 76 68             	pushl  0x68(%esi)
8010534d:	e8 5e c4 ff ff       	call   801017b0 <iput>
  end_op();
80105352:	e8 b9 d8 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105357:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	31 c0                	xor    %eax,%eax
}
8010535f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5d                   	pop    %ebp
80105365:	c3                   	ret    
80105366:	8d 76 00             	lea    0x0(%esi),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	53                   	push   %ebx
80105374:	e8 97 c5 ff ff       	call   80101910 <iunlockput>
    end_op();
80105379:	e8 92 d8 ff ff       	call   80102c10 <end_op>
    return -1;
8010537e:	83 c4 10             	add    $0x10,%esp
80105381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105386:	eb d7                	jmp    8010535f <sys_chdir+0x6f>
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105390:	e8 7b d8 ff ff       	call   80102c10 <end_op>
    return -1;
80105395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539a:	eb c3                	jmp    8010535f <sys_chdir+0x6f>
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_exec>:

int
sys_exec(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801053ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053b2:	50                   	push   %eax
801053b3:	6a 00                	push   $0x0
801053b5:	e8 36 f5 ff ff       	call   801048f0 <argstr>
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	85 c0                	test   %eax,%eax
801053bf:	0f 88 87 00 00 00    	js     8010544c <sys_exec+0xac>
801053c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053cb:	83 ec 08             	sub    $0x8,%esp
801053ce:	50                   	push   %eax
801053cf:	6a 01                	push   $0x1
801053d1:	e8 6a f4 ff ff       	call   80104840 <argint>
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	85 c0                	test   %eax,%eax
801053db:	78 6f                	js     8010544c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801053e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801053e8:	68 80 00 00 00       	push   $0x80
801053ed:	6a 00                	push   $0x0
801053ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053f5:	50                   	push   %eax
801053f6:	e8 45 f1 ff ff       	call   80104540 <memset>
801053fb:	83 c4 10             	add    $0x10,%esp
801053fe:	eb 2c                	jmp    8010542c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105400:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105406:	85 c0                	test   %eax,%eax
80105408:	74 56                	je     80105460 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010540a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105416:	52                   	push   %edx
80105417:	50                   	push   %eax
80105418:	e8 b3 f3 ff ff       	call   801047d0 <fetchstr>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 28                	js     8010544c <sys_exec+0xac>
  for(i=0;; i++){
80105424:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105427:	83 fb 20             	cmp    $0x20,%ebx
8010542a:	74 20                	je     8010544c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010542c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105432:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	57                   	push   %edi
8010543d:	01 f0                	add    %esi,%eax
8010543f:	50                   	push   %eax
80105440:	e8 4b f3 ff ff       	call   80104790 <fetchint>
80105445:	83 c4 10             	add    $0x10,%esp
80105448:	85 c0                	test   %eax,%eax
8010544a:	79 b4                	jns    80105400 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010544c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010544f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105454:	5b                   	pop    %ebx
80105455:	5e                   	pop    %esi
80105456:	5f                   	pop    %edi
80105457:	5d                   	pop    %ebp
80105458:	c3                   	ret    
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105460:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105466:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105469:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105470:	00 00 00 00 
  return exec(path, argv);
80105474:	50                   	push   %eax
80105475:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010547b:	e8 90 b5 ff ff       	call   80100a10 <exec>
80105480:	83 c4 10             	add    $0x10,%esp
}
80105483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_pipe>:

int
sys_pipe(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105496:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105499:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010549c:	6a 08                	push   $0x8
8010549e:	50                   	push   %eax
8010549f:	6a 00                	push   $0x0
801054a1:	e8 ea f3 ff ff       	call   80104890 <argptr>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	0f 88 ae 00 00 00    	js     8010555f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801054b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054b4:	83 ec 08             	sub    $0x8,%esp
801054b7:	50                   	push   %eax
801054b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054bb:	50                   	push   %eax
801054bc:	e8 7f dd ff ff       	call   80103240 <pipealloc>
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	85 c0                	test   %eax,%eax
801054c6:	0f 88 93 00 00 00    	js     8010555f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054d1:	e8 0a e3 ff ff       	call   801037e0 <myproc>
801054d6:	eb 10                	jmp    801054e8 <sys_pipe+0x58>
801054d8:	90                   	nop
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054e0:	83 c3 01             	add    $0x1,%ebx
801054e3:	83 fb 10             	cmp    $0x10,%ebx
801054e6:	74 60                	je     80105548 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801054e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801054ec:	85 f6                	test   %esi,%esi
801054ee:	75 f0                	jne    801054e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801054f0:	8d 73 08             	lea    0x8(%ebx),%esi
801054f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801054fa:	e8 e1 e2 ff ff       	call   801037e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ff:	31 d2                	xor    %edx,%edx
80105501:	eb 0d                	jmp    80105510 <sys_pipe+0x80>
80105503:	90                   	nop
80105504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105508:	83 c2 01             	add    $0x1,%edx
8010550b:	83 fa 10             	cmp    $0x10,%edx
8010550e:	74 28                	je     80105538 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105510:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105514:	85 c9                	test   %ecx,%ecx
80105516:	75 f0                	jne    80105508 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105518:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010551c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010551f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105521:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105524:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105527:	31 c0                	xor    %eax,%eax
}
80105529:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010552c:	5b                   	pop    %ebx
8010552d:	5e                   	pop    %esi
8010552e:	5f                   	pop    %edi
8010552f:	5d                   	pop    %ebp
80105530:	c3                   	ret    
80105531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105538:	e8 a3 e2 ff ff       	call   801037e0 <myproc>
8010553d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105544:	00 
80105545:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	ff 75 e0             	pushl  -0x20(%ebp)
8010554e:	e8 ed b8 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105553:	58                   	pop    %eax
80105554:	ff 75 e4             	pushl  -0x1c(%ebp)
80105557:	e8 e4 b8 ff ff       	call   80100e40 <fileclose>
    return -1;
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105564:	eb c3                	jmp    80105529 <sys_pipe+0x99>
80105566:	66 90                	xchg   %ax,%ax
80105568:	66 90                	xchg   %ax,%ax
8010556a:	66 90                	xchg   %ax,%ax
8010556c:	66 90                	xchg   %ax,%ax
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105573:	5d                   	pop    %ebp
  return fork();
80105574:	e9 07 e4 ff ff       	jmp    80103980 <fork>
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_exit>:

int
sys_exit(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  exit();
80105586:	e8 95 e6 ff ff       	call   80103c20 <exit>
  return 0;  // not reached
}
8010558b:	31 c0                	xor    %eax,%eax
8010558d:	c9                   	leave  
8010558e:	c3                   	ret    
8010558f:	90                   	nop

80105590 <sys_wait>:

int
sys_wait(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105593:	5d                   	pop    %ebp
  return wait();
80105594:	e9 c7 e8 ff ff       	jmp    80103e60 <wait>
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_kill>:

int
sys_kill(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a9:	50                   	push   %eax
801055aa:	6a 00                	push   $0x0
801055ac:	e8 8f f2 ff ff       	call   80104840 <argint>
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	85 c0                	test   %eax,%eax
801055b6:	78 18                	js     801055d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	ff 75 f4             	pushl  -0xc(%ebp)
801055be:	e8 ed e9 ff ff       	call   80103fb0 <kill>
801055c3:	83 c4 10             	add    $0x10,%esp
}
801055c6:	c9                   	leave  
801055c7:	c3                   	ret    
801055c8:	90                   	nop
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_getpid>:

int
sys_getpid(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801055e6:	e8 f5 e1 ff ff       	call   801037e0 <myproc>
801055eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801055ee:	c9                   	leave  
801055ef:	c3                   	ret    

801055f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 3e f2 ff ff       	call   80104840 <argint>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 27                	js     80105630 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105609:	e8 d2 e1 ff ff       	call   801037e0 <myproc>
  if(growproc(n) < 0)
8010560e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105611:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105613:	ff 75 f4             	pushl  -0xc(%ebp)
80105616:	e8 e5 e2 ff ff       	call   80103900 <growproc>
8010561b:	83 c4 10             	add    $0x10,%esp
8010561e:	85 c0                	test   %eax,%eax
80105620:	78 0e                	js     80105630 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105622:	89 d8                	mov    %ebx,%eax
80105624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105627:	c9                   	leave  
80105628:	c3                   	ret    
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105630:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105635:	eb eb                	jmp    80105622 <sys_sbrk+0x32>
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_sleep>:

int
sys_sleep(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105644:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105647:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010564a:	50                   	push   %eax
8010564b:	6a 00                	push   $0x0
8010564d:	e8 ee f1 ff ff       	call   80104840 <argint>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	85 c0                	test   %eax,%eax
80105657:	0f 88 8a 00 00 00    	js     801056e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	68 40 49 11 80       	push   $0x80114940
80105665:	e8 c6 ed ff ff       	call   80104430 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010566a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010566d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105670:	8b 1d 80 51 11 80    	mov    0x80115180,%ebx
  while(ticks - ticks0 < n){
80105676:	85 d2                	test   %edx,%edx
80105678:	75 27                	jne    801056a1 <sys_sleep+0x61>
8010567a:	eb 54                	jmp    801056d0 <sys_sleep+0x90>
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105680:	83 ec 08             	sub    $0x8,%esp
80105683:	68 40 49 11 80       	push   $0x80114940
80105688:	68 80 51 11 80       	push   $0x80115180
8010568d:	e8 0e e7 ff ff       	call   80103da0 <sleep>
  while(ticks - ticks0 < n){
80105692:	a1 80 51 11 80       	mov    0x80115180,%eax
80105697:	83 c4 10             	add    $0x10,%esp
8010569a:	29 d8                	sub    %ebx,%eax
8010569c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010569f:	73 2f                	jae    801056d0 <sys_sleep+0x90>
    if(myproc()->killed){
801056a1:	e8 3a e1 ff ff       	call   801037e0 <myproc>
801056a6:	8b 40 24             	mov    0x24(%eax),%eax
801056a9:	85 c0                	test   %eax,%eax
801056ab:	74 d3                	je     80105680 <sys_sleep+0x40>
      release(&tickslock);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	68 40 49 11 80       	push   $0x80114940
801056b5:	e8 36 ee ff ff       	call   801044f0 <release>
      return -1;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801056c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 40 49 11 80       	push   $0x80114940
801056d8:	e8 13 ee ff ff       	call   801044f0 <release>
  return 0;
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	31 c0                	xor    %eax,%eax
}
801056e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
    return -1;
801056e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ec:	eb f4                	jmp    801056e2 <sys_sleep+0xa2>
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	53                   	push   %ebx
801056f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056f7:	68 40 49 11 80       	push   $0x80114940
801056fc:	e8 2f ed ff ff       	call   80104430 <acquire>
  xticks = ticks;
80105701:	8b 1d 80 51 11 80    	mov    0x80115180,%ebx
  release(&tickslock);
80105707:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
8010570e:	e8 dd ed ff ff       	call   801044f0 <release>
  return xticks;
}
80105713:	89 d8                	mov    %ebx,%eax
80105715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105718:	c9                   	leave  
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105720 <sys_cps>:

// function to use for displayig curent processess states
int 
sys_cps ( void ) {
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
  return cps ();
}
80105723:	5d                   	pop    %ebp
  return cps ();
80105724:	e9 c7 e9 ff ff       	jmp    801040f0 <cps>

80105729 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105729:	1e                   	push   %ds
  pushl %es
8010572a:	06                   	push   %es
  pushl %fs
8010572b:	0f a0                	push   %fs
  pushl %gs
8010572d:	0f a8                	push   %gs
  pushal
8010572f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105730:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105734:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105736:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105738:	54                   	push   %esp
  call trap
80105739:	e8 c2 00 00 00       	call   80105800 <trap>
  addl $4, %esp
8010573e:	83 c4 04             	add    $0x4,%esp

80105741 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105741:	61                   	popa   
  popl %gs
80105742:	0f a9                	pop    %gs
  popl %fs
80105744:	0f a1                	pop    %fs
  popl %es
80105746:	07                   	pop    %es
  popl %ds
80105747:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105748:	83 c4 08             	add    $0x8,%esp
  iret
8010574b:	cf                   	iret   
8010574c:	66 90                	xchg   %ax,%ax
8010574e:	66 90                	xchg   %ax,%ax

80105750 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105750:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105751:	31 c0                	xor    %eax,%eax
{
80105753:	89 e5                	mov    %esp,%ebp
80105755:	83 ec 08             	sub    $0x8,%esp
80105758:	90                   	nop
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105760:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105767:	c7 04 c5 82 49 11 80 	movl   $0x8e000008,-0x7feeb67e(,%eax,8)
8010576e:	08 00 00 8e 
80105772:	66 89 14 c5 80 49 11 	mov    %dx,-0x7feeb680(,%eax,8)
80105779:	80 
8010577a:	c1 ea 10             	shr    $0x10,%edx
8010577d:	66 89 14 c5 86 49 11 	mov    %dx,-0x7feeb67a(,%eax,8)
80105784:	80 
  for(i = 0; i < 256; i++)
80105785:	83 c0 01             	add    $0x1,%eax
80105788:	3d 00 01 00 00       	cmp    $0x100,%eax
8010578d:	75 d1                	jne    80105760 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010578f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105794:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105797:	c7 05 82 4b 11 80 08 	movl   $0xef000008,0x80114b82
8010579e:	00 00 ef 
  initlock(&tickslock, "time");
801057a1:	68 bd 77 10 80       	push   $0x801077bd
801057a6:	68 40 49 11 80       	push   $0x80114940
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057ab:	66 a3 80 4b 11 80    	mov    %ax,0x80114b80
801057b1:	c1 e8 10             	shr    $0x10,%eax
801057b4:	66 a3 86 4b 11 80    	mov    %ax,0x80114b86
  initlock(&tickslock, "time");
801057ba:	e8 31 eb ff ff       	call   801042f0 <initlock>
}
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	c9                   	leave  
801057c3:	c3                   	ret    
801057c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057d0 <idtinit>:

void
idtinit(void)
{
801057d0:	55                   	push   %ebp
  pd[0] = size-1;
801057d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057d6:	89 e5                	mov    %esp,%ebp
801057d8:	83 ec 10             	sub    $0x10,%esp
801057db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057df:	b8 80 49 11 80       	mov    $0x80114980,%eax
801057e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057e8:	c1 e8 10             	shr    $0x10,%eax
801057eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801057ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
80105806:	83 ec 1c             	sub    $0x1c,%esp
80105809:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010580c:	8b 47 30             	mov    0x30(%edi),%eax
8010580f:	83 f8 40             	cmp    $0x40,%eax
80105812:	0f 84 f0 00 00 00    	je     80105908 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105818:	83 e8 20             	sub    $0x20,%eax
8010581b:	83 f8 1f             	cmp    $0x1f,%eax
8010581e:	77 10                	ja     80105830 <trap+0x30>
80105820:	ff 24 85 64 78 10 80 	jmp    *-0x7fef879c(,%eax,4)
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105830:	e8 ab df ff ff       	call   801037e0 <myproc>
80105835:	85 c0                	test   %eax,%eax
80105837:	8b 5f 38             	mov    0x38(%edi),%ebx
8010583a:	0f 84 14 02 00 00    	je     80105a54 <trap+0x254>
80105840:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105844:	0f 84 0a 02 00 00    	je     80105a54 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010584a:	0f 20 d1             	mov    %cr2,%ecx
8010584d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105850:	e8 6b df ff ff       	call   801037c0 <cpuid>
80105855:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105858:	8b 47 34             	mov    0x34(%edi),%eax
8010585b:	8b 77 30             	mov    0x30(%edi),%esi
8010585e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105861:	e8 7a df ff ff       	call   801037e0 <myproc>
80105866:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105869:	e8 72 df ff ff       	call   801037e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010586e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105871:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105874:	51                   	push   %ecx
80105875:	53                   	push   %ebx
80105876:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105877:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010587a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010587d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010587e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105881:	52                   	push   %edx
80105882:	ff 70 10             	pushl  0x10(%eax)
80105885:	68 20 78 10 80       	push   $0x80107820
8010588a:	e8 d1 ad ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010588f:	83 c4 20             	add    $0x20,%esp
80105892:	e8 49 df ff ff       	call   801037e0 <myproc>
80105897:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010589e:	e8 3d df ff ff       	call   801037e0 <myproc>
801058a3:	85 c0                	test   %eax,%eax
801058a5:	74 1d                	je     801058c4 <trap+0xc4>
801058a7:	e8 34 df ff ff       	call   801037e0 <myproc>
801058ac:	8b 50 24             	mov    0x24(%eax),%edx
801058af:	85 d2                	test   %edx,%edx
801058b1:	74 11                	je     801058c4 <trap+0xc4>
801058b3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058b7:	83 e0 03             	and    $0x3,%eax
801058ba:	66 83 f8 03          	cmp    $0x3,%ax
801058be:	0f 84 4c 01 00 00    	je     80105a10 <trap+0x210>
    exit();


  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058c4:	e8 17 df ff ff       	call   801037e0 <myproc>
801058c9:	85 c0                	test   %eax,%eax
801058cb:	74 0b                	je     801058d8 <trap+0xd8>
801058cd:	e8 0e df ff ff       	call   801037e0 <myproc>
801058d2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058d6:	74 68                	je     80105940 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058d8:	e8 03 df ff ff       	call   801037e0 <myproc>
801058dd:	85 c0                	test   %eax,%eax
801058df:	74 19                	je     801058fa <trap+0xfa>
801058e1:	e8 fa de ff ff       	call   801037e0 <myproc>
801058e6:	8b 40 24             	mov    0x24(%eax),%eax
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 0d                	je     801058fa <trap+0xfa>
801058ed:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058f1:	83 e0 03             	and    $0x3,%eax
801058f4:	66 83 f8 03          	cmp    $0x3,%ax
801058f8:	74 37                	je     80105931 <trap+0x131>
    exit();
}
801058fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058fd:	5b                   	pop    %ebx
801058fe:	5e                   	pop    %esi
801058ff:	5f                   	pop    %edi
80105900:	5d                   	pop    %ebp
80105901:	c3                   	ret    
80105902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105908:	e8 d3 de ff ff       	call   801037e0 <myproc>
8010590d:	8b 58 24             	mov    0x24(%eax),%ebx
80105910:	85 db                	test   %ebx,%ebx
80105912:	0f 85 e8 00 00 00    	jne    80105a00 <trap+0x200>
    myproc()->tf = tf;
80105918:	e8 c3 de ff ff       	call   801037e0 <myproc>
8010591d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105920:	e8 0b f0 ff ff       	call   80104930 <syscall>
    if(myproc()->killed)
80105925:	e8 b6 de ff ff       	call   801037e0 <myproc>
8010592a:	8b 48 24             	mov    0x24(%eax),%ecx
8010592d:	85 c9                	test   %ecx,%ecx
8010592f:	74 c9                	je     801058fa <trap+0xfa>
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
      exit();
80105938:	e9 e3 e2 ff ff       	jmp    80103c20 <exit>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105940:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105944:	75 92                	jne    801058d8 <trap+0xd8>
    yield();
80105946:	e8 05 e4 ff ff       	call   80103d50 <yield>
8010594b:	eb 8b                	jmp    801058d8 <trap+0xd8>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105950:	e8 6b de ff ff       	call   801037c0 <cpuid>
80105955:	85 c0                	test   %eax,%eax
80105957:	0f 84 c3 00 00 00    	je     80105a20 <trap+0x220>
    lapiceoi();
8010595d:	e8 ee cd ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105962:	e8 79 de ff ff       	call   801037e0 <myproc>
80105967:	85 c0                	test   %eax,%eax
80105969:	0f 85 38 ff ff ff    	jne    801058a7 <trap+0xa7>
8010596f:	e9 50 ff ff ff       	jmp    801058c4 <trap+0xc4>
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105978:	e8 93 cc ff ff       	call   80102610 <kbdintr>
    lapiceoi();
8010597d:	e8 ce cd ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105982:	e8 59 de ff ff       	call   801037e0 <myproc>
80105987:	85 c0                	test   %eax,%eax
80105989:	0f 85 18 ff ff ff    	jne    801058a7 <trap+0xa7>
8010598f:	e9 30 ff ff ff       	jmp    801058c4 <trap+0xc4>
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105998:	e8 53 02 00 00       	call   80105bf0 <uartintr>
    lapiceoi();
8010599d:	e8 ae cd ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059a2:	e8 39 de ff ff       	call   801037e0 <myproc>
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 85 f8 fe ff ff    	jne    801058a7 <trap+0xa7>
801059af:	e9 10 ff ff ff       	jmp    801058c4 <trap+0xc4>
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059b8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059bc:	8b 77 38             	mov    0x38(%edi),%esi
801059bf:	e8 fc dd ff ff       	call   801037c0 <cpuid>
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	50                   	push   %eax
801059c7:	68 c8 77 10 80       	push   $0x801077c8
801059cc:	e8 8f ac ff ff       	call   80100660 <cprintf>
    lapiceoi();
801059d1:	e8 7a cd ff ff       	call   80102750 <lapiceoi>
    break;
801059d6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d9:	e8 02 de ff ff       	call   801037e0 <myproc>
801059de:	85 c0                	test   %eax,%eax
801059e0:	0f 85 c1 fe ff ff    	jne    801058a7 <trap+0xa7>
801059e6:	e9 d9 fe ff ff       	jmp    801058c4 <trap+0xc4>
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801059f0:	e8 8b c6 ff ff       	call   80102080 <ideintr>
801059f5:	e9 63 ff ff ff       	jmp    8010595d <trap+0x15d>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105a00:	e8 1b e2 ff ff       	call   80103c20 <exit>
80105a05:	e9 0e ff ff ff       	jmp    80105918 <trap+0x118>
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105a10:	e8 0b e2 ff ff       	call   80103c20 <exit>
80105a15:	e9 aa fe ff ff       	jmp    801058c4 <trap+0xc4>
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	68 40 49 11 80       	push   $0x80114940
80105a28:	e8 03 ea ff ff       	call   80104430 <acquire>
      wakeup(&ticks);
80105a2d:	c7 04 24 80 51 11 80 	movl   $0x80115180,(%esp)
      ticks++;
80105a34:	83 05 80 51 11 80 01 	addl   $0x1,0x80115180
      wakeup(&ticks);
80105a3b:	e8 10 e5 ff ff       	call   80103f50 <wakeup>
      release(&tickslock);
80105a40:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
80105a47:	e8 a4 ea ff ff       	call   801044f0 <release>
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	e9 09 ff ff ff       	jmp    8010595d <trap+0x15d>
80105a54:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a57:	e8 64 dd ff ff       	call   801037c0 <cpuid>
80105a5c:	83 ec 0c             	sub    $0xc,%esp
80105a5f:	56                   	push   %esi
80105a60:	53                   	push   %ebx
80105a61:	50                   	push   %eax
80105a62:	ff 77 30             	pushl  0x30(%edi)
80105a65:	68 ec 77 10 80       	push   $0x801077ec
80105a6a:	e8 f1 ab ff ff       	call   80100660 <cprintf>
      panic("trap");
80105a6f:	83 c4 14             	add    $0x14,%esp
80105a72:	68 c2 77 10 80       	push   $0x801077c2
80105a77:	e8 14 a9 ff ff       	call   80100390 <panic>
80105a7c:	66 90                	xchg   %ax,%ax
80105a7e:	66 90                	xchg   %ax,%ax

80105a80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a80:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105a85:	55                   	push   %ebp
80105a86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a88:	85 c0                	test   %eax,%eax
80105a8a:	74 1c                	je     80105aa8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a92:	a8 01                	test   $0x1,%al
80105a94:	74 12                	je     80105aa8 <uartgetc+0x28>
80105a96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a9c:	0f b6 c0             	movzbl %al,%eax
}
80105a9f:	5d                   	pop    %ebp
80105aa0:	c3                   	ret    
80105aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aad:	5d                   	pop    %ebp
80105aae:	c3                   	ret    
80105aaf:	90                   	nop

80105ab0 <uartputc.part.0>:
uartputc(int c)
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
80105ab6:	89 c7                	mov    %eax,%edi
80105ab8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105abd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ac2:	83 ec 0c             	sub    $0xc,%esp
80105ac5:	eb 1b                	jmp    80105ae2 <uartputc.part.0+0x32>
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	6a 0a                	push   $0xa
80105ad5:	e8 96 cc ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	83 eb 01             	sub    $0x1,%ebx
80105ae0:	74 07                	je     80105ae9 <uartputc.part.0+0x39>
80105ae2:	89 f2                	mov    %esi,%edx
80105ae4:	ec                   	in     (%dx),%al
80105ae5:	a8 20                	test   $0x20,%al
80105ae7:	74 e7                	je     80105ad0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ae9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aee:	89 f8                	mov    %edi,%eax
80105af0:	ee                   	out    %al,(%dx)
}
80105af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af4:	5b                   	pop    %ebx
80105af5:	5e                   	pop    %esi
80105af6:	5f                   	pop    %edi
80105af7:	5d                   	pop    %ebp
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <uartinit>:
{
80105b00:	55                   	push   %ebp
80105b01:	31 c9                	xor    %ecx,%ecx
80105b03:	89 c8                	mov    %ecx,%eax
80105b05:	89 e5                	mov    %esp,%ebp
80105b07:	57                   	push   %edi
80105b08:	56                   	push   %esi
80105b09:	53                   	push   %ebx
80105b0a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b0f:	89 da                	mov    %ebx,%edx
80105b11:	83 ec 0c             	sub    $0xc,%esp
80105b14:	ee                   	out    %al,(%dx)
80105b15:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b1f:	89 fa                	mov    %edi,%edx
80105b21:	ee                   	out    %al,(%dx)
80105b22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b2c:	ee                   	out    %al,(%dx)
80105b2d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b32:	89 c8                	mov    %ecx,%eax
80105b34:	89 f2                	mov    %esi,%edx
80105b36:	ee                   	out    %al,(%dx)
80105b37:	b8 03 00 00 00       	mov    $0x3,%eax
80105b3c:	89 fa                	mov    %edi,%edx
80105b3e:	ee                   	out    %al,(%dx)
80105b3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b44:	89 c8                	mov    %ecx,%eax
80105b46:	ee                   	out    %al,(%dx)
80105b47:	b8 01 00 00 00       	mov    $0x1,%eax
80105b4c:	89 f2                	mov    %esi,%edx
80105b4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b54:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b55:	3c ff                	cmp    $0xff,%al
80105b57:	74 5a                	je     80105bb3 <uartinit+0xb3>
  uart = 1;
80105b59:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b60:	00 00 00 
80105b63:	89 da                	mov    %ebx,%edx
80105b65:	ec                   	in     (%dx),%al
80105b66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b6b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b6c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105b6f:	bb e4 78 10 80       	mov    $0x801078e4,%ebx
  ioapicenable(IRQ_COM1, 0);
80105b74:	6a 00                	push   $0x0
80105b76:	6a 04                	push   $0x4
80105b78:	e8 53 c7 ff ff       	call   801022d0 <ioapicenable>
80105b7d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105b80:	b8 78 00 00 00       	mov    $0x78,%eax
80105b85:	eb 13                	jmp    80105b9a <uartinit+0x9a>
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	0f be 03             	movsbl (%ebx),%eax
80105b96:	84 c0                	test   %al,%al
80105b98:	74 19                	je     80105bb3 <uartinit+0xb3>
  if(!uart)
80105b9a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105ba0:	85 d2                	test   %edx,%edx
80105ba2:	74 ec                	je     80105b90 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105ba4:	83 c3 01             	add    $0x1,%ebx
80105ba7:	e8 04 ff ff ff       	call   80105ab0 <uartputc.part.0>
80105bac:	0f be 03             	movsbl (%ebx),%eax
80105baf:	84 c0                	test   %al,%al
80105bb1:	75 e7                	jne    80105b9a <uartinit+0x9a>
}
80105bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb6:	5b                   	pop    %ebx
80105bb7:	5e                   	pop    %esi
80105bb8:	5f                   	pop    %edi
80105bb9:	5d                   	pop    %ebp
80105bba:	c3                   	ret    
80105bbb:	90                   	nop
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <uartputc>:
  if(!uart)
80105bc0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105bc6:	55                   	push   %ebp
80105bc7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105bc9:	85 d2                	test   %edx,%edx
{
80105bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bce:	74 10                	je     80105be0 <uartputc+0x20>
}
80105bd0:	5d                   	pop    %ebp
80105bd1:	e9 da fe ff ff       	jmp    80105ab0 <uartputc.part.0>
80105bd6:	8d 76 00             	lea    0x0(%esi),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105be0:	5d                   	pop    %ebp
80105be1:	c3                   	ret    
80105be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <uartintr>:

void
uartintr(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105bf6:	68 80 5a 10 80       	push   $0x80105a80
80105bfb:	e8 10 ac ff ff       	call   80100810 <consoleintr>
}
80105c00:	83 c4 10             	add    $0x10,%esp
80105c03:	c9                   	leave  
80105c04:	c3                   	ret    

80105c05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $0
80105c07:	6a 00                	push   $0x0
  jmp alltraps
80105c09:	e9 1b fb ff ff       	jmp    80105729 <alltraps>

80105c0e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $1
80105c10:	6a 01                	push   $0x1
  jmp alltraps
80105c12:	e9 12 fb ff ff       	jmp    80105729 <alltraps>

80105c17 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $2
80105c19:	6a 02                	push   $0x2
  jmp alltraps
80105c1b:	e9 09 fb ff ff       	jmp    80105729 <alltraps>

80105c20 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $3
80105c22:	6a 03                	push   $0x3
  jmp alltraps
80105c24:	e9 00 fb ff ff       	jmp    80105729 <alltraps>

80105c29 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $4
80105c2b:	6a 04                	push   $0x4
  jmp alltraps
80105c2d:	e9 f7 fa ff ff       	jmp    80105729 <alltraps>

80105c32 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $5
80105c34:	6a 05                	push   $0x5
  jmp alltraps
80105c36:	e9 ee fa ff ff       	jmp    80105729 <alltraps>

80105c3b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $6
80105c3d:	6a 06                	push   $0x6
  jmp alltraps
80105c3f:	e9 e5 fa ff ff       	jmp    80105729 <alltraps>

80105c44 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $7
80105c46:	6a 07                	push   $0x7
  jmp alltraps
80105c48:	e9 dc fa ff ff       	jmp    80105729 <alltraps>

80105c4d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c4d:	6a 08                	push   $0x8
  jmp alltraps
80105c4f:	e9 d5 fa ff ff       	jmp    80105729 <alltraps>

80105c54 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c54:	6a 00                	push   $0x0
  pushl $9
80105c56:	6a 09                	push   $0x9
  jmp alltraps
80105c58:	e9 cc fa ff ff       	jmp    80105729 <alltraps>

80105c5d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c5d:	6a 0a                	push   $0xa
  jmp alltraps
80105c5f:	e9 c5 fa ff ff       	jmp    80105729 <alltraps>

80105c64 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c64:	6a 0b                	push   $0xb
  jmp alltraps
80105c66:	e9 be fa ff ff       	jmp    80105729 <alltraps>

80105c6b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c6b:	6a 0c                	push   $0xc
  jmp alltraps
80105c6d:	e9 b7 fa ff ff       	jmp    80105729 <alltraps>

80105c72 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c72:	6a 0d                	push   $0xd
  jmp alltraps
80105c74:	e9 b0 fa ff ff       	jmp    80105729 <alltraps>

80105c79 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c79:	6a 0e                	push   $0xe
  jmp alltraps
80105c7b:	e9 a9 fa ff ff       	jmp    80105729 <alltraps>

80105c80 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $15
80105c82:	6a 0f                	push   $0xf
  jmp alltraps
80105c84:	e9 a0 fa ff ff       	jmp    80105729 <alltraps>

80105c89 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $16
80105c8b:	6a 10                	push   $0x10
  jmp alltraps
80105c8d:	e9 97 fa ff ff       	jmp    80105729 <alltraps>

80105c92 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c92:	6a 11                	push   $0x11
  jmp alltraps
80105c94:	e9 90 fa ff ff       	jmp    80105729 <alltraps>

80105c99 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $18
80105c9b:	6a 12                	push   $0x12
  jmp alltraps
80105c9d:	e9 87 fa ff ff       	jmp    80105729 <alltraps>

80105ca2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $19
80105ca4:	6a 13                	push   $0x13
  jmp alltraps
80105ca6:	e9 7e fa ff ff       	jmp    80105729 <alltraps>

80105cab <vector20>:
.globl vector20
vector20:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $20
80105cad:	6a 14                	push   $0x14
  jmp alltraps
80105caf:	e9 75 fa ff ff       	jmp    80105729 <alltraps>

80105cb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $21
80105cb6:	6a 15                	push   $0x15
  jmp alltraps
80105cb8:	e9 6c fa ff ff       	jmp    80105729 <alltraps>

80105cbd <vector22>:
.globl vector22
vector22:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $22
80105cbf:	6a 16                	push   $0x16
  jmp alltraps
80105cc1:	e9 63 fa ff ff       	jmp    80105729 <alltraps>

80105cc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $23
80105cc8:	6a 17                	push   $0x17
  jmp alltraps
80105cca:	e9 5a fa ff ff       	jmp    80105729 <alltraps>

80105ccf <vector24>:
.globl vector24
vector24:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $24
80105cd1:	6a 18                	push   $0x18
  jmp alltraps
80105cd3:	e9 51 fa ff ff       	jmp    80105729 <alltraps>

80105cd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $25
80105cda:	6a 19                	push   $0x19
  jmp alltraps
80105cdc:	e9 48 fa ff ff       	jmp    80105729 <alltraps>

80105ce1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $26
80105ce3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ce5:	e9 3f fa ff ff       	jmp    80105729 <alltraps>

80105cea <vector27>:
.globl vector27
vector27:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $27
80105cec:	6a 1b                	push   $0x1b
  jmp alltraps
80105cee:	e9 36 fa ff ff       	jmp    80105729 <alltraps>

80105cf3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $28
80105cf5:	6a 1c                	push   $0x1c
  jmp alltraps
80105cf7:	e9 2d fa ff ff       	jmp    80105729 <alltraps>

80105cfc <vector29>:
.globl vector29
vector29:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $29
80105cfe:	6a 1d                	push   $0x1d
  jmp alltraps
80105d00:	e9 24 fa ff ff       	jmp    80105729 <alltraps>

80105d05 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $30
80105d07:	6a 1e                	push   $0x1e
  jmp alltraps
80105d09:	e9 1b fa ff ff       	jmp    80105729 <alltraps>

80105d0e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $31
80105d10:	6a 1f                	push   $0x1f
  jmp alltraps
80105d12:	e9 12 fa ff ff       	jmp    80105729 <alltraps>

80105d17 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $32
80105d19:	6a 20                	push   $0x20
  jmp alltraps
80105d1b:	e9 09 fa ff ff       	jmp    80105729 <alltraps>

80105d20 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $33
80105d22:	6a 21                	push   $0x21
  jmp alltraps
80105d24:	e9 00 fa ff ff       	jmp    80105729 <alltraps>

80105d29 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $34
80105d2b:	6a 22                	push   $0x22
  jmp alltraps
80105d2d:	e9 f7 f9 ff ff       	jmp    80105729 <alltraps>

80105d32 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $35
80105d34:	6a 23                	push   $0x23
  jmp alltraps
80105d36:	e9 ee f9 ff ff       	jmp    80105729 <alltraps>

80105d3b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $36
80105d3d:	6a 24                	push   $0x24
  jmp alltraps
80105d3f:	e9 e5 f9 ff ff       	jmp    80105729 <alltraps>

80105d44 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $37
80105d46:	6a 25                	push   $0x25
  jmp alltraps
80105d48:	e9 dc f9 ff ff       	jmp    80105729 <alltraps>

80105d4d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $38
80105d4f:	6a 26                	push   $0x26
  jmp alltraps
80105d51:	e9 d3 f9 ff ff       	jmp    80105729 <alltraps>

80105d56 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $39
80105d58:	6a 27                	push   $0x27
  jmp alltraps
80105d5a:	e9 ca f9 ff ff       	jmp    80105729 <alltraps>

80105d5f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $40
80105d61:	6a 28                	push   $0x28
  jmp alltraps
80105d63:	e9 c1 f9 ff ff       	jmp    80105729 <alltraps>

80105d68 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $41
80105d6a:	6a 29                	push   $0x29
  jmp alltraps
80105d6c:	e9 b8 f9 ff ff       	jmp    80105729 <alltraps>

80105d71 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $42
80105d73:	6a 2a                	push   $0x2a
  jmp alltraps
80105d75:	e9 af f9 ff ff       	jmp    80105729 <alltraps>

80105d7a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $43
80105d7c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d7e:	e9 a6 f9 ff ff       	jmp    80105729 <alltraps>

80105d83 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $44
80105d85:	6a 2c                	push   $0x2c
  jmp alltraps
80105d87:	e9 9d f9 ff ff       	jmp    80105729 <alltraps>

80105d8c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $45
80105d8e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d90:	e9 94 f9 ff ff       	jmp    80105729 <alltraps>

80105d95 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $46
80105d97:	6a 2e                	push   $0x2e
  jmp alltraps
80105d99:	e9 8b f9 ff ff       	jmp    80105729 <alltraps>

80105d9e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $47
80105da0:	6a 2f                	push   $0x2f
  jmp alltraps
80105da2:	e9 82 f9 ff ff       	jmp    80105729 <alltraps>

80105da7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $48
80105da9:	6a 30                	push   $0x30
  jmp alltraps
80105dab:	e9 79 f9 ff ff       	jmp    80105729 <alltraps>

80105db0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $49
80105db2:	6a 31                	push   $0x31
  jmp alltraps
80105db4:	e9 70 f9 ff ff       	jmp    80105729 <alltraps>

80105db9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $50
80105dbb:	6a 32                	push   $0x32
  jmp alltraps
80105dbd:	e9 67 f9 ff ff       	jmp    80105729 <alltraps>

80105dc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $51
80105dc4:	6a 33                	push   $0x33
  jmp alltraps
80105dc6:	e9 5e f9 ff ff       	jmp    80105729 <alltraps>

80105dcb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $52
80105dcd:	6a 34                	push   $0x34
  jmp alltraps
80105dcf:	e9 55 f9 ff ff       	jmp    80105729 <alltraps>

80105dd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $53
80105dd6:	6a 35                	push   $0x35
  jmp alltraps
80105dd8:	e9 4c f9 ff ff       	jmp    80105729 <alltraps>

80105ddd <vector54>:
.globl vector54
vector54:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $54
80105ddf:	6a 36                	push   $0x36
  jmp alltraps
80105de1:	e9 43 f9 ff ff       	jmp    80105729 <alltraps>

80105de6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $55
80105de8:	6a 37                	push   $0x37
  jmp alltraps
80105dea:	e9 3a f9 ff ff       	jmp    80105729 <alltraps>

80105def <vector56>:
.globl vector56
vector56:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $56
80105df1:	6a 38                	push   $0x38
  jmp alltraps
80105df3:	e9 31 f9 ff ff       	jmp    80105729 <alltraps>

80105df8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $57
80105dfa:	6a 39                	push   $0x39
  jmp alltraps
80105dfc:	e9 28 f9 ff ff       	jmp    80105729 <alltraps>

80105e01 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $58
80105e03:	6a 3a                	push   $0x3a
  jmp alltraps
80105e05:	e9 1f f9 ff ff       	jmp    80105729 <alltraps>

80105e0a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $59
80105e0c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e0e:	e9 16 f9 ff ff       	jmp    80105729 <alltraps>

80105e13 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $60
80105e15:	6a 3c                	push   $0x3c
  jmp alltraps
80105e17:	e9 0d f9 ff ff       	jmp    80105729 <alltraps>

80105e1c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $61
80105e1e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e20:	e9 04 f9 ff ff       	jmp    80105729 <alltraps>

80105e25 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $62
80105e27:	6a 3e                	push   $0x3e
  jmp alltraps
80105e29:	e9 fb f8 ff ff       	jmp    80105729 <alltraps>

80105e2e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $63
80105e30:	6a 3f                	push   $0x3f
  jmp alltraps
80105e32:	e9 f2 f8 ff ff       	jmp    80105729 <alltraps>

80105e37 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $64
80105e39:	6a 40                	push   $0x40
  jmp alltraps
80105e3b:	e9 e9 f8 ff ff       	jmp    80105729 <alltraps>

80105e40 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $65
80105e42:	6a 41                	push   $0x41
  jmp alltraps
80105e44:	e9 e0 f8 ff ff       	jmp    80105729 <alltraps>

80105e49 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $66
80105e4b:	6a 42                	push   $0x42
  jmp alltraps
80105e4d:	e9 d7 f8 ff ff       	jmp    80105729 <alltraps>

80105e52 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $67
80105e54:	6a 43                	push   $0x43
  jmp alltraps
80105e56:	e9 ce f8 ff ff       	jmp    80105729 <alltraps>

80105e5b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $68
80105e5d:	6a 44                	push   $0x44
  jmp alltraps
80105e5f:	e9 c5 f8 ff ff       	jmp    80105729 <alltraps>

80105e64 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $69
80105e66:	6a 45                	push   $0x45
  jmp alltraps
80105e68:	e9 bc f8 ff ff       	jmp    80105729 <alltraps>

80105e6d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $70
80105e6f:	6a 46                	push   $0x46
  jmp alltraps
80105e71:	e9 b3 f8 ff ff       	jmp    80105729 <alltraps>

80105e76 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $71
80105e78:	6a 47                	push   $0x47
  jmp alltraps
80105e7a:	e9 aa f8 ff ff       	jmp    80105729 <alltraps>

80105e7f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $72
80105e81:	6a 48                	push   $0x48
  jmp alltraps
80105e83:	e9 a1 f8 ff ff       	jmp    80105729 <alltraps>

80105e88 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $73
80105e8a:	6a 49                	push   $0x49
  jmp alltraps
80105e8c:	e9 98 f8 ff ff       	jmp    80105729 <alltraps>

80105e91 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $74
80105e93:	6a 4a                	push   $0x4a
  jmp alltraps
80105e95:	e9 8f f8 ff ff       	jmp    80105729 <alltraps>

80105e9a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $75
80105e9c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e9e:	e9 86 f8 ff ff       	jmp    80105729 <alltraps>

80105ea3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $76
80105ea5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ea7:	e9 7d f8 ff ff       	jmp    80105729 <alltraps>

80105eac <vector77>:
.globl vector77
vector77:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $77
80105eae:	6a 4d                	push   $0x4d
  jmp alltraps
80105eb0:	e9 74 f8 ff ff       	jmp    80105729 <alltraps>

80105eb5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $78
80105eb7:	6a 4e                	push   $0x4e
  jmp alltraps
80105eb9:	e9 6b f8 ff ff       	jmp    80105729 <alltraps>

80105ebe <vector79>:
.globl vector79
vector79:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $79
80105ec0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ec2:	e9 62 f8 ff ff       	jmp    80105729 <alltraps>

80105ec7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $80
80105ec9:	6a 50                	push   $0x50
  jmp alltraps
80105ecb:	e9 59 f8 ff ff       	jmp    80105729 <alltraps>

80105ed0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $81
80105ed2:	6a 51                	push   $0x51
  jmp alltraps
80105ed4:	e9 50 f8 ff ff       	jmp    80105729 <alltraps>

80105ed9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $82
80105edb:	6a 52                	push   $0x52
  jmp alltraps
80105edd:	e9 47 f8 ff ff       	jmp    80105729 <alltraps>

80105ee2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $83
80105ee4:	6a 53                	push   $0x53
  jmp alltraps
80105ee6:	e9 3e f8 ff ff       	jmp    80105729 <alltraps>

80105eeb <vector84>:
.globl vector84
vector84:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $84
80105eed:	6a 54                	push   $0x54
  jmp alltraps
80105eef:	e9 35 f8 ff ff       	jmp    80105729 <alltraps>

80105ef4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $85
80105ef6:	6a 55                	push   $0x55
  jmp alltraps
80105ef8:	e9 2c f8 ff ff       	jmp    80105729 <alltraps>

80105efd <vector86>:
.globl vector86
vector86:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $86
80105eff:	6a 56                	push   $0x56
  jmp alltraps
80105f01:	e9 23 f8 ff ff       	jmp    80105729 <alltraps>

80105f06 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $87
80105f08:	6a 57                	push   $0x57
  jmp alltraps
80105f0a:	e9 1a f8 ff ff       	jmp    80105729 <alltraps>

80105f0f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $88
80105f11:	6a 58                	push   $0x58
  jmp alltraps
80105f13:	e9 11 f8 ff ff       	jmp    80105729 <alltraps>

80105f18 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $89
80105f1a:	6a 59                	push   $0x59
  jmp alltraps
80105f1c:	e9 08 f8 ff ff       	jmp    80105729 <alltraps>

80105f21 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $90
80105f23:	6a 5a                	push   $0x5a
  jmp alltraps
80105f25:	e9 ff f7 ff ff       	jmp    80105729 <alltraps>

80105f2a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $91
80105f2c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f2e:	e9 f6 f7 ff ff       	jmp    80105729 <alltraps>

80105f33 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $92
80105f35:	6a 5c                	push   $0x5c
  jmp alltraps
80105f37:	e9 ed f7 ff ff       	jmp    80105729 <alltraps>

80105f3c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $93
80105f3e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f40:	e9 e4 f7 ff ff       	jmp    80105729 <alltraps>

80105f45 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $94
80105f47:	6a 5e                	push   $0x5e
  jmp alltraps
80105f49:	e9 db f7 ff ff       	jmp    80105729 <alltraps>

80105f4e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $95
80105f50:	6a 5f                	push   $0x5f
  jmp alltraps
80105f52:	e9 d2 f7 ff ff       	jmp    80105729 <alltraps>

80105f57 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $96
80105f59:	6a 60                	push   $0x60
  jmp alltraps
80105f5b:	e9 c9 f7 ff ff       	jmp    80105729 <alltraps>

80105f60 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $97
80105f62:	6a 61                	push   $0x61
  jmp alltraps
80105f64:	e9 c0 f7 ff ff       	jmp    80105729 <alltraps>

80105f69 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $98
80105f6b:	6a 62                	push   $0x62
  jmp alltraps
80105f6d:	e9 b7 f7 ff ff       	jmp    80105729 <alltraps>

80105f72 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $99
80105f74:	6a 63                	push   $0x63
  jmp alltraps
80105f76:	e9 ae f7 ff ff       	jmp    80105729 <alltraps>

80105f7b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $100
80105f7d:	6a 64                	push   $0x64
  jmp alltraps
80105f7f:	e9 a5 f7 ff ff       	jmp    80105729 <alltraps>

80105f84 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $101
80105f86:	6a 65                	push   $0x65
  jmp alltraps
80105f88:	e9 9c f7 ff ff       	jmp    80105729 <alltraps>

80105f8d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $102
80105f8f:	6a 66                	push   $0x66
  jmp alltraps
80105f91:	e9 93 f7 ff ff       	jmp    80105729 <alltraps>

80105f96 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $103
80105f98:	6a 67                	push   $0x67
  jmp alltraps
80105f9a:	e9 8a f7 ff ff       	jmp    80105729 <alltraps>

80105f9f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $104
80105fa1:	6a 68                	push   $0x68
  jmp alltraps
80105fa3:	e9 81 f7 ff ff       	jmp    80105729 <alltraps>

80105fa8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $105
80105faa:	6a 69                	push   $0x69
  jmp alltraps
80105fac:	e9 78 f7 ff ff       	jmp    80105729 <alltraps>

80105fb1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $106
80105fb3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fb5:	e9 6f f7 ff ff       	jmp    80105729 <alltraps>

80105fba <vector107>:
.globl vector107
vector107:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $107
80105fbc:	6a 6b                	push   $0x6b
  jmp alltraps
80105fbe:	e9 66 f7 ff ff       	jmp    80105729 <alltraps>

80105fc3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $108
80105fc5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fc7:	e9 5d f7 ff ff       	jmp    80105729 <alltraps>

80105fcc <vector109>:
.globl vector109
vector109:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $109
80105fce:	6a 6d                	push   $0x6d
  jmp alltraps
80105fd0:	e9 54 f7 ff ff       	jmp    80105729 <alltraps>

80105fd5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $110
80105fd7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fd9:	e9 4b f7 ff ff       	jmp    80105729 <alltraps>

80105fde <vector111>:
.globl vector111
vector111:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $111
80105fe0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fe2:	e9 42 f7 ff ff       	jmp    80105729 <alltraps>

80105fe7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $112
80105fe9:	6a 70                	push   $0x70
  jmp alltraps
80105feb:	e9 39 f7 ff ff       	jmp    80105729 <alltraps>

80105ff0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $113
80105ff2:	6a 71                	push   $0x71
  jmp alltraps
80105ff4:	e9 30 f7 ff ff       	jmp    80105729 <alltraps>

80105ff9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $114
80105ffb:	6a 72                	push   $0x72
  jmp alltraps
80105ffd:	e9 27 f7 ff ff       	jmp    80105729 <alltraps>

80106002 <vector115>:
.globl vector115
vector115:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $115
80106004:	6a 73                	push   $0x73
  jmp alltraps
80106006:	e9 1e f7 ff ff       	jmp    80105729 <alltraps>

8010600b <vector116>:
.globl vector116
vector116:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $116
8010600d:	6a 74                	push   $0x74
  jmp alltraps
8010600f:	e9 15 f7 ff ff       	jmp    80105729 <alltraps>

80106014 <vector117>:
.globl vector117
vector117:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $117
80106016:	6a 75                	push   $0x75
  jmp alltraps
80106018:	e9 0c f7 ff ff       	jmp    80105729 <alltraps>

8010601d <vector118>:
.globl vector118
vector118:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $118
8010601f:	6a 76                	push   $0x76
  jmp alltraps
80106021:	e9 03 f7 ff ff       	jmp    80105729 <alltraps>

80106026 <vector119>:
.globl vector119
vector119:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $119
80106028:	6a 77                	push   $0x77
  jmp alltraps
8010602a:	e9 fa f6 ff ff       	jmp    80105729 <alltraps>

8010602f <vector120>:
.globl vector120
vector120:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $120
80106031:	6a 78                	push   $0x78
  jmp alltraps
80106033:	e9 f1 f6 ff ff       	jmp    80105729 <alltraps>

80106038 <vector121>:
.globl vector121
vector121:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $121
8010603a:	6a 79                	push   $0x79
  jmp alltraps
8010603c:	e9 e8 f6 ff ff       	jmp    80105729 <alltraps>

80106041 <vector122>:
.globl vector122
vector122:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $122
80106043:	6a 7a                	push   $0x7a
  jmp alltraps
80106045:	e9 df f6 ff ff       	jmp    80105729 <alltraps>

8010604a <vector123>:
.globl vector123
vector123:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $123
8010604c:	6a 7b                	push   $0x7b
  jmp alltraps
8010604e:	e9 d6 f6 ff ff       	jmp    80105729 <alltraps>

80106053 <vector124>:
.globl vector124
vector124:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $124
80106055:	6a 7c                	push   $0x7c
  jmp alltraps
80106057:	e9 cd f6 ff ff       	jmp    80105729 <alltraps>

8010605c <vector125>:
.globl vector125
vector125:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $125
8010605e:	6a 7d                	push   $0x7d
  jmp alltraps
80106060:	e9 c4 f6 ff ff       	jmp    80105729 <alltraps>

80106065 <vector126>:
.globl vector126
vector126:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $126
80106067:	6a 7e                	push   $0x7e
  jmp alltraps
80106069:	e9 bb f6 ff ff       	jmp    80105729 <alltraps>

8010606e <vector127>:
.globl vector127
vector127:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $127
80106070:	6a 7f                	push   $0x7f
  jmp alltraps
80106072:	e9 b2 f6 ff ff       	jmp    80105729 <alltraps>

80106077 <vector128>:
.globl vector128
vector128:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $128
80106079:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010607e:	e9 a6 f6 ff ff       	jmp    80105729 <alltraps>

80106083 <vector129>:
.globl vector129
vector129:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $129
80106085:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010608a:	e9 9a f6 ff ff       	jmp    80105729 <alltraps>

8010608f <vector130>:
.globl vector130
vector130:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $130
80106091:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106096:	e9 8e f6 ff ff       	jmp    80105729 <alltraps>

8010609b <vector131>:
.globl vector131
vector131:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $131
8010609d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060a2:	e9 82 f6 ff ff       	jmp    80105729 <alltraps>

801060a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $132
801060a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060ae:	e9 76 f6 ff ff       	jmp    80105729 <alltraps>

801060b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $133
801060b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060ba:	e9 6a f6 ff ff       	jmp    80105729 <alltraps>

801060bf <vector134>:
.globl vector134
vector134:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $134
801060c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060c6:	e9 5e f6 ff ff       	jmp    80105729 <alltraps>

801060cb <vector135>:
.globl vector135
vector135:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $135
801060cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060d2:	e9 52 f6 ff ff       	jmp    80105729 <alltraps>

801060d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $136
801060d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060de:	e9 46 f6 ff ff       	jmp    80105729 <alltraps>

801060e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $137
801060e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060ea:	e9 3a f6 ff ff       	jmp    80105729 <alltraps>

801060ef <vector138>:
.globl vector138
vector138:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $138
801060f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060f6:	e9 2e f6 ff ff       	jmp    80105729 <alltraps>

801060fb <vector139>:
.globl vector139
vector139:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $139
801060fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106102:	e9 22 f6 ff ff       	jmp    80105729 <alltraps>

80106107 <vector140>:
.globl vector140
vector140:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $140
80106109:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010610e:	e9 16 f6 ff ff       	jmp    80105729 <alltraps>

80106113 <vector141>:
.globl vector141
vector141:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $141
80106115:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010611a:	e9 0a f6 ff ff       	jmp    80105729 <alltraps>

8010611f <vector142>:
.globl vector142
vector142:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $142
80106121:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106126:	e9 fe f5 ff ff       	jmp    80105729 <alltraps>

8010612b <vector143>:
.globl vector143
vector143:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $143
8010612d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106132:	e9 f2 f5 ff ff       	jmp    80105729 <alltraps>

80106137 <vector144>:
.globl vector144
vector144:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $144
80106139:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010613e:	e9 e6 f5 ff ff       	jmp    80105729 <alltraps>

80106143 <vector145>:
.globl vector145
vector145:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $145
80106145:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010614a:	e9 da f5 ff ff       	jmp    80105729 <alltraps>

8010614f <vector146>:
.globl vector146
vector146:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $146
80106151:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106156:	e9 ce f5 ff ff       	jmp    80105729 <alltraps>

8010615b <vector147>:
.globl vector147
vector147:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $147
8010615d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106162:	e9 c2 f5 ff ff       	jmp    80105729 <alltraps>

80106167 <vector148>:
.globl vector148
vector148:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $148
80106169:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010616e:	e9 b6 f5 ff ff       	jmp    80105729 <alltraps>

80106173 <vector149>:
.globl vector149
vector149:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $149
80106175:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010617a:	e9 aa f5 ff ff       	jmp    80105729 <alltraps>

8010617f <vector150>:
.globl vector150
vector150:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $150
80106181:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106186:	e9 9e f5 ff ff       	jmp    80105729 <alltraps>

8010618b <vector151>:
.globl vector151
vector151:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $151
8010618d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106192:	e9 92 f5 ff ff       	jmp    80105729 <alltraps>

80106197 <vector152>:
.globl vector152
vector152:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $152
80106199:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010619e:	e9 86 f5 ff ff       	jmp    80105729 <alltraps>

801061a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $153
801061a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061aa:	e9 7a f5 ff ff       	jmp    80105729 <alltraps>

801061af <vector154>:
.globl vector154
vector154:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $154
801061b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061b6:	e9 6e f5 ff ff       	jmp    80105729 <alltraps>

801061bb <vector155>:
.globl vector155
vector155:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $155
801061bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061c2:	e9 62 f5 ff ff       	jmp    80105729 <alltraps>

801061c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $156
801061c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061ce:	e9 56 f5 ff ff       	jmp    80105729 <alltraps>

801061d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $157
801061d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061da:	e9 4a f5 ff ff       	jmp    80105729 <alltraps>

801061df <vector158>:
.globl vector158
vector158:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $158
801061e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061e6:	e9 3e f5 ff ff       	jmp    80105729 <alltraps>

801061eb <vector159>:
.globl vector159
vector159:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $159
801061ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061f2:	e9 32 f5 ff ff       	jmp    80105729 <alltraps>

801061f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $160
801061f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061fe:	e9 26 f5 ff ff       	jmp    80105729 <alltraps>

80106203 <vector161>:
.globl vector161
vector161:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $161
80106205:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010620a:	e9 1a f5 ff ff       	jmp    80105729 <alltraps>

8010620f <vector162>:
.globl vector162
vector162:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $162
80106211:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106216:	e9 0e f5 ff ff       	jmp    80105729 <alltraps>

8010621b <vector163>:
.globl vector163
vector163:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $163
8010621d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106222:	e9 02 f5 ff ff       	jmp    80105729 <alltraps>

80106227 <vector164>:
.globl vector164
vector164:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $164
80106229:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010622e:	e9 f6 f4 ff ff       	jmp    80105729 <alltraps>

80106233 <vector165>:
.globl vector165
vector165:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $165
80106235:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010623a:	e9 ea f4 ff ff       	jmp    80105729 <alltraps>

8010623f <vector166>:
.globl vector166
vector166:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $166
80106241:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106246:	e9 de f4 ff ff       	jmp    80105729 <alltraps>

8010624b <vector167>:
.globl vector167
vector167:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $167
8010624d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106252:	e9 d2 f4 ff ff       	jmp    80105729 <alltraps>

80106257 <vector168>:
.globl vector168
vector168:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $168
80106259:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010625e:	e9 c6 f4 ff ff       	jmp    80105729 <alltraps>

80106263 <vector169>:
.globl vector169
vector169:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $169
80106265:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010626a:	e9 ba f4 ff ff       	jmp    80105729 <alltraps>

8010626f <vector170>:
.globl vector170
vector170:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $170
80106271:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106276:	e9 ae f4 ff ff       	jmp    80105729 <alltraps>

8010627b <vector171>:
.globl vector171
vector171:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $171
8010627d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106282:	e9 a2 f4 ff ff       	jmp    80105729 <alltraps>

80106287 <vector172>:
.globl vector172
vector172:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $172
80106289:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010628e:	e9 96 f4 ff ff       	jmp    80105729 <alltraps>

80106293 <vector173>:
.globl vector173
vector173:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $173
80106295:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010629a:	e9 8a f4 ff ff       	jmp    80105729 <alltraps>

8010629f <vector174>:
.globl vector174
vector174:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $174
801062a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062a6:	e9 7e f4 ff ff       	jmp    80105729 <alltraps>

801062ab <vector175>:
.globl vector175
vector175:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $175
801062ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062b2:	e9 72 f4 ff ff       	jmp    80105729 <alltraps>

801062b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $176
801062b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062be:	e9 66 f4 ff ff       	jmp    80105729 <alltraps>

801062c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $177
801062c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062ca:	e9 5a f4 ff ff       	jmp    80105729 <alltraps>

801062cf <vector178>:
.globl vector178
vector178:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $178
801062d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062d6:	e9 4e f4 ff ff       	jmp    80105729 <alltraps>

801062db <vector179>:
.globl vector179
vector179:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $179
801062dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062e2:	e9 42 f4 ff ff       	jmp    80105729 <alltraps>

801062e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $180
801062e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062ee:	e9 36 f4 ff ff       	jmp    80105729 <alltraps>

801062f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $181
801062f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062fa:	e9 2a f4 ff ff       	jmp    80105729 <alltraps>

801062ff <vector182>:
.globl vector182
vector182:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $182
80106301:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106306:	e9 1e f4 ff ff       	jmp    80105729 <alltraps>

8010630b <vector183>:
.globl vector183
vector183:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $183
8010630d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106312:	e9 12 f4 ff ff       	jmp    80105729 <alltraps>

80106317 <vector184>:
.globl vector184
vector184:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $184
80106319:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010631e:	e9 06 f4 ff ff       	jmp    80105729 <alltraps>

80106323 <vector185>:
.globl vector185
vector185:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $185
80106325:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010632a:	e9 fa f3 ff ff       	jmp    80105729 <alltraps>

8010632f <vector186>:
.globl vector186
vector186:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $186
80106331:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106336:	e9 ee f3 ff ff       	jmp    80105729 <alltraps>

8010633b <vector187>:
.globl vector187
vector187:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $187
8010633d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106342:	e9 e2 f3 ff ff       	jmp    80105729 <alltraps>

80106347 <vector188>:
.globl vector188
vector188:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $188
80106349:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010634e:	e9 d6 f3 ff ff       	jmp    80105729 <alltraps>

80106353 <vector189>:
.globl vector189
vector189:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $189
80106355:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010635a:	e9 ca f3 ff ff       	jmp    80105729 <alltraps>

8010635f <vector190>:
.globl vector190
vector190:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $190
80106361:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106366:	e9 be f3 ff ff       	jmp    80105729 <alltraps>

8010636b <vector191>:
.globl vector191
vector191:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $191
8010636d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106372:	e9 b2 f3 ff ff       	jmp    80105729 <alltraps>

80106377 <vector192>:
.globl vector192
vector192:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $192
80106379:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010637e:	e9 a6 f3 ff ff       	jmp    80105729 <alltraps>

80106383 <vector193>:
.globl vector193
vector193:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $193
80106385:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010638a:	e9 9a f3 ff ff       	jmp    80105729 <alltraps>

8010638f <vector194>:
.globl vector194
vector194:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $194
80106391:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106396:	e9 8e f3 ff ff       	jmp    80105729 <alltraps>

8010639b <vector195>:
.globl vector195
vector195:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $195
8010639d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063a2:	e9 82 f3 ff ff       	jmp    80105729 <alltraps>

801063a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $196
801063a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063ae:	e9 76 f3 ff ff       	jmp    80105729 <alltraps>

801063b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $197
801063b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063ba:	e9 6a f3 ff ff       	jmp    80105729 <alltraps>

801063bf <vector198>:
.globl vector198
vector198:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $198
801063c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063c6:	e9 5e f3 ff ff       	jmp    80105729 <alltraps>

801063cb <vector199>:
.globl vector199
vector199:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $199
801063cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063d2:	e9 52 f3 ff ff       	jmp    80105729 <alltraps>

801063d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $200
801063d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063de:	e9 46 f3 ff ff       	jmp    80105729 <alltraps>

801063e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $201
801063e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063ea:	e9 3a f3 ff ff       	jmp    80105729 <alltraps>

801063ef <vector202>:
.globl vector202
vector202:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $202
801063f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063f6:	e9 2e f3 ff ff       	jmp    80105729 <alltraps>

801063fb <vector203>:
.globl vector203
vector203:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $203
801063fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106402:	e9 22 f3 ff ff       	jmp    80105729 <alltraps>

80106407 <vector204>:
.globl vector204
vector204:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $204
80106409:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010640e:	e9 16 f3 ff ff       	jmp    80105729 <alltraps>

80106413 <vector205>:
.globl vector205
vector205:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $205
80106415:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010641a:	e9 0a f3 ff ff       	jmp    80105729 <alltraps>

8010641f <vector206>:
.globl vector206
vector206:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $206
80106421:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106426:	e9 fe f2 ff ff       	jmp    80105729 <alltraps>

8010642b <vector207>:
.globl vector207
vector207:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $207
8010642d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106432:	e9 f2 f2 ff ff       	jmp    80105729 <alltraps>

80106437 <vector208>:
.globl vector208
vector208:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $208
80106439:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010643e:	e9 e6 f2 ff ff       	jmp    80105729 <alltraps>

80106443 <vector209>:
.globl vector209
vector209:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $209
80106445:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010644a:	e9 da f2 ff ff       	jmp    80105729 <alltraps>

8010644f <vector210>:
.globl vector210
vector210:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $210
80106451:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106456:	e9 ce f2 ff ff       	jmp    80105729 <alltraps>

8010645b <vector211>:
.globl vector211
vector211:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $211
8010645d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106462:	e9 c2 f2 ff ff       	jmp    80105729 <alltraps>

80106467 <vector212>:
.globl vector212
vector212:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $212
80106469:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010646e:	e9 b6 f2 ff ff       	jmp    80105729 <alltraps>

80106473 <vector213>:
.globl vector213
vector213:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $213
80106475:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010647a:	e9 aa f2 ff ff       	jmp    80105729 <alltraps>

8010647f <vector214>:
.globl vector214
vector214:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $214
80106481:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106486:	e9 9e f2 ff ff       	jmp    80105729 <alltraps>

8010648b <vector215>:
.globl vector215
vector215:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $215
8010648d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106492:	e9 92 f2 ff ff       	jmp    80105729 <alltraps>

80106497 <vector216>:
.globl vector216
vector216:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $216
80106499:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010649e:	e9 86 f2 ff ff       	jmp    80105729 <alltraps>

801064a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $217
801064a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064aa:	e9 7a f2 ff ff       	jmp    80105729 <alltraps>

801064af <vector218>:
.globl vector218
vector218:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $218
801064b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064b6:	e9 6e f2 ff ff       	jmp    80105729 <alltraps>

801064bb <vector219>:
.globl vector219
vector219:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $219
801064bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064c2:	e9 62 f2 ff ff       	jmp    80105729 <alltraps>

801064c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $220
801064c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064ce:	e9 56 f2 ff ff       	jmp    80105729 <alltraps>

801064d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $221
801064d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064da:	e9 4a f2 ff ff       	jmp    80105729 <alltraps>

801064df <vector222>:
.globl vector222
vector222:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $222
801064e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064e6:	e9 3e f2 ff ff       	jmp    80105729 <alltraps>

801064eb <vector223>:
.globl vector223
vector223:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $223
801064ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064f2:	e9 32 f2 ff ff       	jmp    80105729 <alltraps>

801064f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $224
801064f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064fe:	e9 26 f2 ff ff       	jmp    80105729 <alltraps>

80106503 <vector225>:
.globl vector225
vector225:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $225
80106505:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010650a:	e9 1a f2 ff ff       	jmp    80105729 <alltraps>

8010650f <vector226>:
.globl vector226
vector226:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $226
80106511:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106516:	e9 0e f2 ff ff       	jmp    80105729 <alltraps>

8010651b <vector227>:
.globl vector227
vector227:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $227
8010651d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106522:	e9 02 f2 ff ff       	jmp    80105729 <alltraps>

80106527 <vector228>:
.globl vector228
vector228:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $228
80106529:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010652e:	e9 f6 f1 ff ff       	jmp    80105729 <alltraps>

80106533 <vector229>:
.globl vector229
vector229:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $229
80106535:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010653a:	e9 ea f1 ff ff       	jmp    80105729 <alltraps>

8010653f <vector230>:
.globl vector230
vector230:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $230
80106541:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106546:	e9 de f1 ff ff       	jmp    80105729 <alltraps>

8010654b <vector231>:
.globl vector231
vector231:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $231
8010654d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106552:	e9 d2 f1 ff ff       	jmp    80105729 <alltraps>

80106557 <vector232>:
.globl vector232
vector232:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $232
80106559:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010655e:	e9 c6 f1 ff ff       	jmp    80105729 <alltraps>

80106563 <vector233>:
.globl vector233
vector233:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $233
80106565:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010656a:	e9 ba f1 ff ff       	jmp    80105729 <alltraps>

8010656f <vector234>:
.globl vector234
vector234:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $234
80106571:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106576:	e9 ae f1 ff ff       	jmp    80105729 <alltraps>

8010657b <vector235>:
.globl vector235
vector235:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $235
8010657d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106582:	e9 a2 f1 ff ff       	jmp    80105729 <alltraps>

80106587 <vector236>:
.globl vector236
vector236:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $236
80106589:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010658e:	e9 96 f1 ff ff       	jmp    80105729 <alltraps>

80106593 <vector237>:
.globl vector237
vector237:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $237
80106595:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010659a:	e9 8a f1 ff ff       	jmp    80105729 <alltraps>

8010659f <vector238>:
.globl vector238
vector238:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $238
801065a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065a6:	e9 7e f1 ff ff       	jmp    80105729 <alltraps>

801065ab <vector239>:
.globl vector239
vector239:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $239
801065ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065b2:	e9 72 f1 ff ff       	jmp    80105729 <alltraps>

801065b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $240
801065b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065be:	e9 66 f1 ff ff       	jmp    80105729 <alltraps>

801065c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $241
801065c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065ca:	e9 5a f1 ff ff       	jmp    80105729 <alltraps>

801065cf <vector242>:
.globl vector242
vector242:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $242
801065d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065d6:	e9 4e f1 ff ff       	jmp    80105729 <alltraps>

801065db <vector243>:
.globl vector243
vector243:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $243
801065dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065e2:	e9 42 f1 ff ff       	jmp    80105729 <alltraps>

801065e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $244
801065e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065ee:	e9 36 f1 ff ff       	jmp    80105729 <alltraps>

801065f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $245
801065f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065fa:	e9 2a f1 ff ff       	jmp    80105729 <alltraps>

801065ff <vector246>:
.globl vector246
vector246:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $246
80106601:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106606:	e9 1e f1 ff ff       	jmp    80105729 <alltraps>

8010660b <vector247>:
.globl vector247
vector247:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $247
8010660d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106612:	e9 12 f1 ff ff       	jmp    80105729 <alltraps>

80106617 <vector248>:
.globl vector248
vector248:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $248
80106619:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010661e:	e9 06 f1 ff ff       	jmp    80105729 <alltraps>

80106623 <vector249>:
.globl vector249
vector249:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $249
80106625:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010662a:	e9 fa f0 ff ff       	jmp    80105729 <alltraps>

8010662f <vector250>:
.globl vector250
vector250:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $250
80106631:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106636:	e9 ee f0 ff ff       	jmp    80105729 <alltraps>

8010663b <vector251>:
.globl vector251
vector251:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $251
8010663d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106642:	e9 e2 f0 ff ff       	jmp    80105729 <alltraps>

80106647 <vector252>:
.globl vector252
vector252:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $252
80106649:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010664e:	e9 d6 f0 ff ff       	jmp    80105729 <alltraps>

80106653 <vector253>:
.globl vector253
vector253:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $253
80106655:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010665a:	e9 ca f0 ff ff       	jmp    80105729 <alltraps>

8010665f <vector254>:
.globl vector254
vector254:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $254
80106661:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106666:	e9 be f0 ff ff       	jmp    80105729 <alltraps>

8010666b <vector255>:
.globl vector255
vector255:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $255
8010666d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106672:	e9 b2 f0 ff ff       	jmp    80105729 <alltraps>
80106677:	66 90                	xchg   %ax,%ax
80106679:	66 90                	xchg   %ax,%ax
8010667b:	66 90                	xchg   %ax,%ax
8010667d:	66 90                	xchg   %ax,%ax
8010667f:	90                   	nop

80106680 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	57                   	push   %edi
80106684:	56                   	push   %esi
80106685:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106686:	89 d3                	mov    %edx,%ebx
{
80106688:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010668a:	c1 eb 16             	shr    $0x16,%ebx
8010668d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106690:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106693:	8b 06                	mov    (%esi),%eax
80106695:	a8 01                	test   $0x1,%al
80106697:	74 27                	je     801066c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106699:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010669e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066a4:	c1 ef 0a             	shr    $0xa,%edi
}
801066a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801066aa:	89 fa                	mov    %edi,%edx
801066ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066b5:	5b                   	pop    %ebx
801066b6:	5e                   	pop    %esi
801066b7:	5f                   	pop    %edi
801066b8:	5d                   	pop    %ebp
801066b9:	c3                   	ret    
801066ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066c0:	85 c9                	test   %ecx,%ecx
801066c2:	74 2c                	je     801066f0 <walkpgdir+0x70>
801066c4:	e8 f7 bd ff ff       	call   801024c0 <kalloc>
801066c9:	85 c0                	test   %eax,%eax
801066cb:	89 c3                	mov    %eax,%ebx
801066cd:	74 21                	je     801066f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066cf:	83 ec 04             	sub    $0x4,%esp
801066d2:	68 00 10 00 00       	push   $0x1000
801066d7:	6a 00                	push   $0x0
801066d9:	50                   	push   %eax
801066da:	e8 61 de ff ff       	call   80104540 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066e5:	83 c4 10             	add    $0x10,%esp
801066e8:	83 c8 07             	or     $0x7,%eax
801066eb:	89 06                	mov    %eax,(%esi)
801066ed:	eb b5                	jmp    801066a4 <walkpgdir+0x24>
801066ef:	90                   	nop
}
801066f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801066f3:	31 c0                	xor    %eax,%eax
}
801066f5:	5b                   	pop    %ebx
801066f6:	5e                   	pop    %esi
801066f7:	5f                   	pop    %edi
801066f8:	5d                   	pop    %ebp
801066f9:	c3                   	ret    
801066fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106700 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	56                   	push   %esi
80106705:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106706:	89 d3                	mov    %edx,%ebx
80106708:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010670e:	83 ec 1c             	sub    $0x1c,%esp
80106711:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106714:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106718:	8b 7d 08             	mov    0x8(%ebp),%edi
8010671b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106720:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106723:	8b 45 0c             	mov    0xc(%ebp),%eax
80106726:	29 df                	sub    %ebx,%edi
80106728:	83 c8 01             	or     $0x1,%eax
8010672b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010672e:	eb 15                	jmp    80106745 <mappages+0x45>
    if(*pte & PTE_P)
80106730:	f6 00 01             	testb  $0x1,(%eax)
80106733:	75 45                	jne    8010677a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106735:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106738:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010673b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010673d:	74 31                	je     80106770 <mappages+0x70>
      break;
    a += PGSIZE;
8010673f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106748:	b9 01 00 00 00       	mov    $0x1,%ecx
8010674d:	89 da                	mov    %ebx,%edx
8010674f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106752:	e8 29 ff ff ff       	call   80106680 <walkpgdir>
80106757:	85 c0                	test   %eax,%eax
80106759:	75 d5                	jne    80106730 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010675b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010675e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106763:	5b                   	pop    %ebx
80106764:	5e                   	pop    %esi
80106765:	5f                   	pop    %edi
80106766:	5d                   	pop    %ebp
80106767:	c3                   	ret    
80106768:	90                   	nop
80106769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106770:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106773:	31 c0                	xor    %eax,%eax
}
80106775:	5b                   	pop    %ebx
80106776:	5e                   	pop    %esi
80106777:	5f                   	pop    %edi
80106778:	5d                   	pop    %ebp
80106779:	c3                   	ret    
      panic("remap");
8010677a:	83 ec 0c             	sub    $0xc,%esp
8010677d:	68 ec 78 10 80       	push   $0x801078ec
80106782:	e8 09 9c ff ff       	call   80100390 <panic>
80106787:	89 f6                	mov    %esi,%esi
80106789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106790 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	57                   	push   %edi
80106794:	56                   	push   %esi
80106795:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106796:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010679c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010679e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067a4:	83 ec 1c             	sub    $0x1c,%esp
801067a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801067aa:	39 d3                	cmp    %edx,%ebx
801067ac:	73 66                	jae    80106814 <deallocuvm.part.0+0x84>
801067ae:	89 d6                	mov    %edx,%esi
801067b0:	eb 3d                	jmp    801067ef <deallocuvm.part.0+0x5f>
801067b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801067b8:	8b 10                	mov    (%eax),%edx
801067ba:	f6 c2 01             	test   $0x1,%dl
801067bd:	74 26                	je     801067e5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067c5:	74 58                	je     8010681f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801067c7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801067ca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801067d3:	52                   	push   %edx
801067d4:	e8 37 bb ff ff       	call   80102310 <kfree>
      *pte = 0;
801067d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067dc:	83 c4 10             	add    $0x10,%esp
801067df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801067e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067eb:	39 f3                	cmp    %esi,%ebx
801067ed:	73 25                	jae    80106814 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067ef:	31 c9                	xor    %ecx,%ecx
801067f1:	89 da                	mov    %ebx,%edx
801067f3:	89 f8                	mov    %edi,%eax
801067f5:	e8 86 fe ff ff       	call   80106680 <walkpgdir>
    if(!pte)
801067fa:	85 c0                	test   %eax,%eax
801067fc:	75 ba                	jne    801067b8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067fe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106804:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010680a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106810:	39 f3                	cmp    %esi,%ebx
80106812:	72 db                	jb     801067ef <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106814:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106817:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010681a:	5b                   	pop    %ebx
8010681b:	5e                   	pop    %esi
8010681c:	5f                   	pop    %edi
8010681d:	5d                   	pop    %ebp
8010681e:	c3                   	ret    
        panic("kfree");
8010681f:	83 ec 0c             	sub    $0xc,%esp
80106822:	68 26 72 10 80       	push   $0x80107226
80106827:	e8 64 9b ff ff       	call   80100390 <panic>
8010682c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106830 <seginit>:
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106836:	e8 85 cf ff ff       	call   801037c0 <cpuid>
8010683b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106841:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106846:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010684a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106851:	ff 00 00 
80106854:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010685b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010685e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106865:	ff 00 00 
80106868:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010686f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106872:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106879:	ff 00 00 
8010687c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106883:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106886:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
8010688d:	ff 00 00 
80106890:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106897:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010689a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010689f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068a3:	c1 e8 10             	shr    $0x10,%eax
801068a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801068aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068ad:	0f 01 10             	lgdtl  (%eax)
}
801068b0:	c9                   	leave  
801068b1:	c3                   	ret    
801068b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068c0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068c0:	a1 84 51 11 80       	mov    0x80115184,%eax
{
801068c5:	55                   	push   %ebp
801068c6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068cd:	0f 22 d8             	mov    %eax,%cr3
}
801068d0:	5d                   	pop    %ebp
801068d1:	c3                   	ret    
801068d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068e0 <switchuvm>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
801068e6:	83 ec 1c             	sub    $0x1c,%esp
801068e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801068ec:	85 db                	test   %ebx,%ebx
801068ee:	0f 84 cb 00 00 00    	je     801069bf <switchuvm+0xdf>
  if(p->kstack == 0)
801068f4:	8b 43 08             	mov    0x8(%ebx),%eax
801068f7:	85 c0                	test   %eax,%eax
801068f9:	0f 84 da 00 00 00    	je     801069d9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801068ff:	8b 43 04             	mov    0x4(%ebx),%eax
80106902:	85 c0                	test   %eax,%eax
80106904:	0f 84 c2 00 00 00    	je     801069cc <switchuvm+0xec>
  pushcli();
8010690a:	e8 51 da ff ff       	call   80104360 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010690f:	e8 3c ce ff ff       	call   80103750 <mycpu>
80106914:	89 c6                	mov    %eax,%esi
80106916:	e8 35 ce ff ff       	call   80103750 <mycpu>
8010691b:	89 c7                	mov    %eax,%edi
8010691d:	e8 2e ce ff ff       	call   80103750 <mycpu>
80106922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106925:	83 c7 08             	add    $0x8,%edi
80106928:	e8 23 ce ff ff       	call   80103750 <mycpu>
8010692d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106930:	83 c0 08             	add    $0x8,%eax
80106933:	ba 67 00 00 00       	mov    $0x67,%edx
80106938:	c1 e8 18             	shr    $0x18,%eax
8010693b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106942:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106949:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010694f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106954:	83 c1 08             	add    $0x8,%ecx
80106957:	c1 e9 10             	shr    $0x10,%ecx
8010695a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106960:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106965:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010696c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106971:	e8 da cd ff ff       	call   80103750 <mycpu>
80106976:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010697d:	e8 ce cd ff ff       	call   80103750 <mycpu>
80106982:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106986:	8b 73 08             	mov    0x8(%ebx),%esi
80106989:	e8 c2 cd ff ff       	call   80103750 <mycpu>
8010698e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106994:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106997:	e8 b4 cd ff ff       	call   80103750 <mycpu>
8010699c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801069a0:	b8 28 00 00 00       	mov    $0x28,%eax
801069a5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069a8:	8b 43 04             	mov    0x4(%ebx),%eax
801069ab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069b0:	0f 22 d8             	mov    %eax,%cr3
}
801069b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069b6:	5b                   	pop    %ebx
801069b7:	5e                   	pop    %esi
801069b8:	5f                   	pop    %edi
801069b9:	5d                   	pop    %ebp
  popcli();
801069ba:	e9 e1 d9 ff ff       	jmp    801043a0 <popcli>
    panic("switchuvm: no process");
801069bf:	83 ec 0c             	sub    $0xc,%esp
801069c2:	68 f2 78 10 80       	push   $0x801078f2
801069c7:	e8 c4 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801069cc:	83 ec 0c             	sub    $0xc,%esp
801069cf:	68 1d 79 10 80       	push   $0x8010791d
801069d4:	e8 b7 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801069d9:	83 ec 0c             	sub    $0xc,%esp
801069dc:	68 08 79 10 80       	push   $0x80107908
801069e1:	e8 aa 99 ff ff       	call   80100390 <panic>
801069e6:	8d 76 00             	lea    0x0(%esi),%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069f0 <inituvm>:
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
801069f6:	83 ec 1c             	sub    $0x1c,%esp
801069f9:	8b 75 10             	mov    0x10(%ebp),%esi
801069fc:	8b 45 08             	mov    0x8(%ebp),%eax
801069ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106a02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106a08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a0b:	77 49                	ja     80106a56 <inituvm+0x66>
  mem = kalloc();
80106a0d:	e8 ae ba ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a12:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106a15:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a17:	68 00 10 00 00       	push   $0x1000
80106a1c:	6a 00                	push   $0x0
80106a1e:	50                   	push   %eax
80106a1f:	e8 1c db ff ff       	call   80104540 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a24:	58                   	pop    %eax
80106a25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a30:	5a                   	pop    %edx
80106a31:	6a 06                	push   $0x6
80106a33:	50                   	push   %eax
80106a34:	31 d2                	xor    %edx,%edx
80106a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a39:	e8 c2 fc ff ff       	call   80106700 <mappages>
  memmove(mem, init, sz);
80106a3e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a41:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a44:	83 c4 10             	add    $0x10,%esp
80106a47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a4d:	5b                   	pop    %ebx
80106a4e:	5e                   	pop    %esi
80106a4f:	5f                   	pop    %edi
80106a50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a51:	e9 9a db ff ff       	jmp    801045f0 <memmove>
    panic("inituvm: more than a page");
80106a56:	83 ec 0c             	sub    $0xc,%esp
80106a59:	68 31 79 10 80       	push   $0x80107931
80106a5e:	e8 2d 99 ff ff       	call   80100390 <panic>
80106a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a70 <loaduvm>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
80106a76:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106a79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a80:	0f 85 91 00 00 00    	jne    80106b17 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106a86:	8b 75 18             	mov    0x18(%ebp),%esi
80106a89:	31 db                	xor    %ebx,%ebx
80106a8b:	85 f6                	test   %esi,%esi
80106a8d:	75 1a                	jne    80106aa9 <loaduvm+0x39>
80106a8f:	eb 6f                	jmp    80106b00 <loaduvm+0x90>
80106a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106aa4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106aa7:	76 57                	jbe    80106b00 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106aac:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaf:	31 c9                	xor    %ecx,%ecx
80106ab1:	01 da                	add    %ebx,%edx
80106ab3:	e8 c8 fb ff ff       	call   80106680 <walkpgdir>
80106ab8:	85 c0                	test   %eax,%eax
80106aba:	74 4e                	je     80106b0a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106abc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106abe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ac1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ac6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106acb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ad1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ad4:	01 d9                	add    %ebx,%ecx
80106ad6:	05 00 00 00 80       	add    $0x80000000,%eax
80106adb:	57                   	push   %edi
80106adc:	51                   	push   %ecx
80106add:	50                   	push   %eax
80106ade:	ff 75 10             	pushl  0x10(%ebp)
80106ae1:	e8 7a ae ff ff       	call   80101960 <readi>
80106ae6:	83 c4 10             	add    $0x10,%esp
80106ae9:	39 f8                	cmp    %edi,%eax
80106aeb:	74 ab                	je     80106a98 <loaduvm+0x28>
}
80106aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b03:	31 c0                	xor    %eax,%eax
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b0a:	83 ec 0c             	sub    $0xc,%esp
80106b0d:	68 4b 79 10 80       	push   $0x8010794b
80106b12:	e8 79 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b17:	83 ec 0c             	sub    $0xc,%esp
80106b1a:	68 ec 79 10 80       	push   $0x801079ec
80106b1f:	e8 6c 98 ff ff       	call   80100390 <panic>
80106b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b30 <allocuvm>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b39:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b3c:	85 ff                	test   %edi,%edi
80106b3e:	0f 88 8e 00 00 00    	js     80106bd2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106b44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b47:	0f 82 93 00 00 00    	jb     80106be0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b50:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b56:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b5c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b5f:	0f 86 7e 00 00 00    	jbe    80106be3 <allocuvm+0xb3>
80106b65:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b6b:	eb 42                	jmp    80106baf <allocuvm+0x7f>
80106b6d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106b70:	83 ec 04             	sub    $0x4,%esp
80106b73:	68 00 10 00 00       	push   $0x1000
80106b78:	6a 00                	push   $0x0
80106b7a:	50                   	push   %eax
80106b7b:	e8 c0 d9 ff ff       	call   80104540 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b80:	58                   	pop    %eax
80106b81:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b87:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b8c:	5a                   	pop    %edx
80106b8d:	6a 06                	push   $0x6
80106b8f:	50                   	push   %eax
80106b90:	89 da                	mov    %ebx,%edx
80106b92:	89 f8                	mov    %edi,%eax
80106b94:	e8 67 fb ff ff       	call   80106700 <mappages>
80106b99:	83 c4 10             	add    $0x10,%esp
80106b9c:	85 c0                	test   %eax,%eax
80106b9e:	78 50                	js     80106bf0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106ba0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ba6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ba9:	0f 86 81 00 00 00    	jbe    80106c30 <allocuvm+0x100>
    mem = kalloc();
80106baf:	e8 0c b9 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80106bb4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106bb6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bb8:	75 b6                	jne    80106b70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 69 79 10 80       	push   $0x80107969
80106bc2:	e8 99 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106bc7:	83 c4 10             	add    $0x10,%esp
80106bca:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bcd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bd0:	77 6e                	ja     80106c40 <allocuvm+0x110>
}
80106bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106bd5:	31 ff                	xor    %edi,%edi
}
80106bd7:	89 f8                	mov    %edi,%eax
80106bd9:	5b                   	pop    %ebx
80106bda:	5e                   	pop    %esi
80106bdb:	5f                   	pop    %edi
80106bdc:	5d                   	pop    %ebp
80106bdd:	c3                   	ret    
80106bde:	66 90                	xchg   %ax,%ax
    return oldsz;
80106be0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be6:	89 f8                	mov    %edi,%eax
80106be8:	5b                   	pop    %ebx
80106be9:	5e                   	pop    %esi
80106bea:	5f                   	pop    %edi
80106beb:	5d                   	pop    %ebp
80106bec:	c3                   	ret    
80106bed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106bf0:	83 ec 0c             	sub    $0xc,%esp
80106bf3:	68 81 79 10 80       	push   $0x80107981
80106bf8:	e8 63 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106bfd:	83 c4 10             	add    $0x10,%esp
80106c00:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c03:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c06:	76 0d                	jbe    80106c15 <allocuvm+0xe5>
80106c08:	89 c1                	mov    %eax,%ecx
80106c0a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c10:	e8 7b fb ff ff       	call   80106790 <deallocuvm.part.0>
      kfree(mem);
80106c15:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c18:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c1a:	56                   	push   %esi
80106c1b:	e8 f0 b6 ff ff       	call   80102310 <kfree>
      return 0;
80106c20:	83 c4 10             	add    $0x10,%esp
}
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	89 f8                	mov    %edi,%eax
80106c28:	5b                   	pop    %ebx
80106c29:	5e                   	pop    %esi
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
80106c30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c36:	5b                   	pop    %ebx
80106c37:	89 f8                	mov    %edi,%eax
80106c39:	5e                   	pop    %esi
80106c3a:	5f                   	pop    %edi
80106c3b:	5d                   	pop    %ebp
80106c3c:	c3                   	ret    
80106c3d:	8d 76 00             	lea    0x0(%esi),%esi
80106c40:	89 c1                	mov    %eax,%ecx
80106c42:	8b 55 10             	mov    0x10(%ebp),%edx
80106c45:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c48:	31 ff                	xor    %edi,%edi
80106c4a:	e8 41 fb ff ff       	call   80106790 <deallocuvm.part.0>
80106c4f:	eb 92                	jmp    80106be3 <allocuvm+0xb3>
80106c51:	eb 0d                	jmp    80106c60 <deallocuvm>
80106c53:	90                   	nop
80106c54:	90                   	nop
80106c55:	90                   	nop
80106c56:	90                   	nop
80106c57:	90                   	nop
80106c58:	90                   	nop
80106c59:	90                   	nop
80106c5a:	90                   	nop
80106c5b:	90                   	nop
80106c5c:	90                   	nop
80106c5d:	90                   	nop
80106c5e:	90                   	nop
80106c5f:	90                   	nop

80106c60 <deallocuvm>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c69:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c6c:	39 d1                	cmp    %edx,%ecx
80106c6e:	73 10                	jae    80106c80 <deallocuvm+0x20>
}
80106c70:	5d                   	pop    %ebp
80106c71:	e9 1a fb ff ff       	jmp    80106790 <deallocuvm.part.0>
80106c76:	8d 76 00             	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c80:	89 d0                	mov    %edx,%eax
80106c82:	5d                   	pop    %ebp
80106c83:	c3                   	ret    
80106c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 0c             	sub    $0xc,%esp
80106c99:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c9c:	85 f6                	test   %esi,%esi
80106c9e:	74 59                	je     80106cf9 <freevm+0x69>
80106ca0:	31 c9                	xor    %ecx,%ecx
80106ca2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ca7:	89 f0                	mov    %esi,%eax
80106ca9:	e8 e2 fa ff ff       	call   80106790 <deallocuvm.part.0>
80106cae:	89 f3                	mov    %esi,%ebx
80106cb0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106cb6:	eb 0f                	jmp    80106cc7 <freevm+0x37>
80106cb8:	90                   	nop
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cc3:	39 fb                	cmp    %edi,%ebx
80106cc5:	74 23                	je     80106cea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cc7:	8b 03                	mov    (%ebx),%eax
80106cc9:	a8 01                	test   $0x1,%al
80106ccb:	74 f3                	je     80106cc0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ccd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106cd2:	83 ec 0c             	sub    $0xc,%esp
80106cd5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cd8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106cdd:	50                   	push   %eax
80106cde:	e8 2d b6 ff ff       	call   80102310 <kfree>
80106ce3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ce6:	39 fb                	cmp    %edi,%ebx
80106ce8:	75 dd                	jne    80106cc7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106cea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf0:	5b                   	pop    %ebx
80106cf1:	5e                   	pop    %esi
80106cf2:	5f                   	pop    %edi
80106cf3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106cf4:	e9 17 b6 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80106cf9:	83 ec 0c             	sub    $0xc,%esp
80106cfc:	68 9d 79 10 80       	push   $0x8010799d
80106d01:	e8 8a 96 ff ff       	call   80100390 <panic>
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <setupkvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	56                   	push   %esi
80106d14:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d15:	e8 a6 b7 ff ff       	call   801024c0 <kalloc>
80106d1a:	85 c0                	test   %eax,%eax
80106d1c:	89 c6                	mov    %eax,%esi
80106d1e:	74 42                	je     80106d62 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d20:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d23:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d28:	68 00 10 00 00       	push   $0x1000
80106d2d:	6a 00                	push   $0x0
80106d2f:	50                   	push   %eax
80106d30:	e8 0b d8 ff ff       	call   80104540 <memset>
80106d35:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d38:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d3b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d3e:	83 ec 08             	sub    $0x8,%esp
80106d41:	8b 13                	mov    (%ebx),%edx
80106d43:	ff 73 0c             	pushl  0xc(%ebx)
80106d46:	50                   	push   %eax
80106d47:	29 c1                	sub    %eax,%ecx
80106d49:	89 f0                	mov    %esi,%eax
80106d4b:	e8 b0 f9 ff ff       	call   80106700 <mappages>
80106d50:	83 c4 10             	add    $0x10,%esp
80106d53:	85 c0                	test   %eax,%eax
80106d55:	78 19                	js     80106d70 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d57:	83 c3 10             	add    $0x10,%ebx
80106d5a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d60:	75 d6                	jne    80106d38 <setupkvm+0x28>
}
80106d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d65:	89 f0                	mov    %esi,%eax
80106d67:	5b                   	pop    %ebx
80106d68:	5e                   	pop    %esi
80106d69:	5d                   	pop    %ebp
80106d6a:	c3                   	ret    
80106d6b:	90                   	nop
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106d70:	83 ec 0c             	sub    $0xc,%esp
80106d73:	56                   	push   %esi
      return 0;
80106d74:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106d76:	e8 15 ff ff ff       	call   80106c90 <freevm>
      return 0;
80106d7b:	83 c4 10             	add    $0x10,%esp
}
80106d7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d81:	89 f0                	mov    %esi,%eax
80106d83:	5b                   	pop    %ebx
80106d84:	5e                   	pop    %esi
80106d85:	5d                   	pop    %ebp
80106d86:	c3                   	ret    
80106d87:	89 f6                	mov    %esi,%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d90 <kvmalloc>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d96:	e8 75 ff ff ff       	call   80106d10 <setupkvm>
80106d9b:	a3 84 51 11 80       	mov    %eax,0x80115184
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106da0:	05 00 00 00 80       	add    $0x80000000,%eax
80106da5:	0f 22 d8             	mov    %eax,%cr3
}
80106da8:	c9                   	leave  
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106db0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106db0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106db1:	31 c9                	xor    %ecx,%ecx
{
80106db3:	89 e5                	mov    %esp,%ebp
80106db5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106db8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbe:	e8 bd f8 ff ff       	call   80106680 <walkpgdir>
  if(pte == 0)
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 05                	je     80106dcc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106dc7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dca:	c9                   	leave  
80106dcb:	c3                   	ret    
    panic("clearpteu");
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	68 ae 79 10 80       	push   $0x801079ae
80106dd4:	e8 b7 95 ff ff       	call   80100390 <panic>
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106de0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106de9:	e8 22 ff ff ff       	call   80106d10 <setupkvm>
80106dee:	85 c0                	test   %eax,%eax
80106df0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106df3:	0f 84 9f 00 00 00    	je     80106e98 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dfc:	85 c9                	test   %ecx,%ecx
80106dfe:	0f 84 94 00 00 00    	je     80106e98 <copyuvm+0xb8>
80106e04:	31 ff                	xor    %edi,%edi
80106e06:	eb 4a                	jmp    80106e52 <copyuvm+0x72>
80106e08:	90                   	nop
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e10:	83 ec 04             	sub    $0x4,%esp
80106e13:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e19:	68 00 10 00 00       	push   $0x1000
80106e1e:	53                   	push   %ebx
80106e1f:	50                   	push   %eax
80106e20:	e8 cb d7 ff ff       	call   801045f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e25:	58                   	pop    %eax
80106e26:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e2c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e31:	5a                   	pop    %edx
80106e32:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e35:	50                   	push   %eax
80106e36:	89 fa                	mov    %edi,%edx
80106e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e3b:	e8 c0 f8 ff ff       	call   80106700 <mappages>
80106e40:	83 c4 10             	add    $0x10,%esp
80106e43:	85 c0                	test   %eax,%eax
80106e45:	78 61                	js     80106ea8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e47:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e4d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e50:	76 46                	jbe    80106e98 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e52:	8b 45 08             	mov    0x8(%ebp),%eax
80106e55:	31 c9                	xor    %ecx,%ecx
80106e57:	89 fa                	mov    %edi,%edx
80106e59:	e8 22 f8 ff ff       	call   80106680 <walkpgdir>
80106e5e:	85 c0                	test   %eax,%eax
80106e60:	74 61                	je     80106ec3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106e62:	8b 00                	mov    (%eax),%eax
80106e64:	a8 01                	test   $0x1,%al
80106e66:	74 4e                	je     80106eb6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106e68:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e6a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80106e6f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106e75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106e78:	e8 43 b6 ff ff       	call   801024c0 <kalloc>
80106e7d:	85 c0                	test   %eax,%eax
80106e7f:	89 c6                	mov    %eax,%esi
80106e81:	75 8d                	jne    80106e10 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106e83:	83 ec 0c             	sub    $0xc,%esp
80106e86:	ff 75 e0             	pushl  -0x20(%ebp)
80106e89:	e8 02 fe ff ff       	call   80106c90 <freevm>
  return 0;
80106e8e:	83 c4 10             	add    $0x10,%esp
80106e91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9e:	5b                   	pop    %ebx
80106e9f:	5e                   	pop    %esi
80106ea0:	5f                   	pop    %edi
80106ea1:	5d                   	pop    %ebp
80106ea2:	c3                   	ret    
80106ea3:	90                   	nop
80106ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106ea8:	83 ec 0c             	sub    $0xc,%esp
80106eab:	56                   	push   %esi
80106eac:	e8 5f b4 ff ff       	call   80102310 <kfree>
      goto bad;
80106eb1:	83 c4 10             	add    $0x10,%esp
80106eb4:	eb cd                	jmp    80106e83 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106eb6:	83 ec 0c             	sub    $0xc,%esp
80106eb9:	68 d2 79 10 80       	push   $0x801079d2
80106ebe:	e8 cd 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106ec3:	83 ec 0c             	sub    $0xc,%esp
80106ec6:	68 b8 79 10 80       	push   $0x801079b8
80106ecb:	e8 c0 94 ff ff       	call   80100390 <panic>

80106ed0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ed0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ed1:	31 c9                	xor    %ecx,%ecx
{
80106ed3:	89 e5                	mov    %esp,%ebp
80106ed5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106edb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ede:	e8 9d f7 ff ff       	call   80106680 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ee3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ee5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106ee6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106ee8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106eed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106ef0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ef5:	83 fa 05             	cmp    $0x5,%edx
80106ef8:	ba 00 00 00 00       	mov    $0x0,%edx
80106efd:	0f 45 c2             	cmovne %edx,%eax
}
80106f00:	c3                   	ret    
80106f01:	eb 0d                	jmp    80106f10 <copyout>
80106f03:	90                   	nop
80106f04:	90                   	nop
80106f05:	90                   	nop
80106f06:	90                   	nop
80106f07:	90                   	nop
80106f08:	90                   	nop
80106f09:	90                   	nop
80106f0a:	90                   	nop
80106f0b:	90                   	nop
80106f0c:	90                   	nop
80106f0d:	90                   	nop
80106f0e:	90                   	nop
80106f0f:	90                   	nop

80106f10 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f22:	85 db                	test   %ebx,%ebx
80106f24:	75 40                	jne    80106f66 <copyout+0x56>
80106f26:	eb 70                	jmp    80106f98 <copyout+0x88>
80106f28:	90                   	nop
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f33:	89 f1                	mov    %esi,%ecx
80106f35:	29 d1                	sub    %edx,%ecx
80106f37:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f3d:	39 d9                	cmp    %ebx,%ecx
80106f3f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f42:	29 f2                	sub    %esi,%edx
80106f44:	83 ec 04             	sub    $0x4,%esp
80106f47:	01 d0                	add    %edx,%eax
80106f49:	51                   	push   %ecx
80106f4a:	57                   	push   %edi
80106f4b:	50                   	push   %eax
80106f4c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f4f:	e8 9c d6 ff ff       	call   801045f0 <memmove>
    len -= n;
    buf += n;
80106f54:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80106f57:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80106f5a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80106f60:	01 cf                	add    %ecx,%edi
  while(len > 0){
80106f62:	29 cb                	sub    %ecx,%ebx
80106f64:	74 32                	je     80106f98 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f66:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f68:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f6e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f74:	56                   	push   %esi
80106f75:	ff 75 08             	pushl  0x8(%ebp)
80106f78:	e8 53 ff ff ff       	call   80106ed0 <uva2ka>
    if(pa0 == 0)
80106f7d:	83 c4 10             	add    $0x10,%esp
80106f80:	85 c0                	test   %eax,%eax
80106f82:	75 ac                	jne    80106f30 <copyout+0x20>
  }
  return 0;
}
80106f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f8c:	5b                   	pop    %ebx
80106f8d:	5e                   	pop    %esi
80106f8e:	5f                   	pop    %edi
80106f8f:	5d                   	pop    %ebp
80106f90:	c3                   	ret    
80106f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f9b:	31 c0                	xor    %eax,%eax
}
80106f9d:	5b                   	pop    %ebx
80106f9e:	5e                   	pop    %esi
80106f9f:	5f                   	pop    %edi
80106fa0:	5d                   	pop    %ebp
80106fa1:	c3                   	ret    
