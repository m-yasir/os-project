
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return -1;
  return 0;
}

int main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0)
      11:	eb 0a                	jmp    1d <main+0x1d>
      13:	90                   	nop
      14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if (fd >= 3)
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	7f 76                	jg     93 <main+0x93>
  while ((fd = open("console", O_RDWR)) >= 0)
      1d:	83 ec 08             	sub    $0x8,%esp
      20:	6a 02                	push   $0x2
      22:	68 f7 10 00 00       	push   $0x10f7
      27:	e8 d6 0b 00 00       	call   c02 <open>
      2c:	83 c4 10             	add    $0x10,%esp
      2f:	85 c0                	test   %eax,%eax
      31:	79 e5                	jns    18 <main+0x18>
      33:	eb 1f                	jmp    54 <main+0x54>
      35:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0)
  {
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
      38:	80 3d a2 16 00 00 20 	cmpb   $0x20,0x16a2
      3f:	74 7a                	je     bb <main+0xbb>

int fork1(void)
{
  int pid;

  pid = fork();
      41:	e8 74 0b 00 00       	call   bba <fork>
  if (pid == -1)
      46:	83 f8 ff             	cmp    $0xffffffff,%eax
      49:	74 3b                	je     86 <main+0x86>
    if (fork1() == 0)
      4b:	85 c0                	test   %eax,%eax
      4d:	74 57                	je     a6 <main+0xa6>
    wait();
      4f:	e8 76 0b 00 00       	call   bca <wait>
  while (getcmd(buf, sizeof(buf)) >= 0)
      54:	83 ec 08             	sub    $0x8,%esp
      57:	6a 64                	push   $0x64
      59:	68 a0 16 00 00       	push   $0x16a0
      5e:	e8 9d 00 00 00       	call   100 <getcmd>
      63:	83 c4 10             	add    $0x10,%esp
      66:	85 c0                	test   %eax,%eax
      68:	78 37                	js     a1 <main+0xa1>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
      6a:	80 3d a0 16 00 00 63 	cmpb   $0x63,0x16a0
      71:	75 ce                	jne    41 <main+0x41>
      73:	80 3d a1 16 00 00 64 	cmpb   $0x64,0x16a1
      7a:	74 bc                	je     38 <main+0x38>
  pid = fork();
      7c:	e8 39 0b 00 00       	call   bba <fork>
  if (pid == -1)
      81:	83 f8 ff             	cmp    $0xffffffff,%eax
      84:	75 c5                	jne    4b <main+0x4b>
    panic("fork");
      86:	83 ec 0c             	sub    $0xc,%esp
      89:	68 82 10 00 00       	push   $0x1082
      8e:	e8 bd 00 00 00       	call   150 <panic>
      close(fd);
      93:	83 ec 0c             	sub    $0xc,%esp
      96:	50                   	push   %eax
      97:	e8 4e 0b 00 00       	call   bea <close>
      break;
      9c:	83 c4 10             	add    $0x10,%esp
      9f:	eb b3                	jmp    54 <main+0x54>
  exit();
      a1:	e8 1c 0b 00 00       	call   bc2 <exit>
      runcmd(parsecmd(buf));
      a6:	83 ec 0c             	sub    $0xc,%esp
      a9:	68 a0 16 00 00       	push   $0x16a0
      ae:	e8 4d 08 00 00       	call   900 <parsecmd>
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 b5 00 00 00       	call   170 <runcmd>
      buf[strlen(buf) - 1] = 0; // chop \n
      bb:	83 ec 0c             	sub    $0xc,%esp
      be:	68 a0 16 00 00       	push   $0x16a0
      c3:	e8 28 09 00 00       	call   9f0 <strlen>
      if (chdir(buf + 3) < 0)
      c8:	c7 04 24 a3 16 00 00 	movl   $0x16a3,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
      cf:	c6 80 9f 16 00 00 00 	movb   $0x0,0x169f(%eax)
      if (chdir(buf + 3) < 0)
      d6:	e8 57 0b 00 00       	call   c32 <chdir>
      db:	83 c4 10             	add    $0x10,%esp
      de:	85 c0                	test   %eax,%eax
      e0:	0f 89 6e ff ff ff    	jns    54 <main+0x54>
        printf(2, "cannot cd %s\n", buf + 3);
      e6:	50                   	push   %eax
      e7:	68 a3 16 00 00       	push   $0x16a3
      ec:	68 ff 10 00 00       	push   $0x10ff
      f1:	6a 02                	push   $0x2
      f3:	e8 18 0c 00 00       	call   d10 <printf>
      f8:	83 c4 10             	add    $0x10,%esp
      fb:	e9 54 ff ff ff       	jmp    54 <main+0x54>

00000100 <getcmd>:
{
     100:	55                   	push   %ebp
     101:	89 e5                	mov    %esp,%ebp
     103:	56                   	push   %esi
     104:	53                   	push   %ebx
     105:	8b 75 0c             	mov    0xc(%ebp),%esi
     108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     10b:	83 ec 08             	sub    $0x8,%esp
     10e:	68 68 10 00 00       	push   $0x1068
     113:	6a 02                	push   $0x2
     115:	e8 f6 0b 00 00       	call   d10 <printf>
  memset(buf, 0, nbuf);
     11a:	83 c4 0c             	add    $0xc,%esp
     11d:	56                   	push   %esi
     11e:	6a 00                	push   $0x0
     120:	53                   	push   %ebx
     121:	e8 fa 08 00 00       	call   a20 <memset>
  gets(buf, nbuf);
     126:	58                   	pop    %eax
     127:	5a                   	pop    %edx
     128:	56                   	push   %esi
     129:	53                   	push   %ebx
     12a:	e8 51 09 00 00       	call   a80 <gets>
  if (buf[0] == 0) // EOF
     12f:	83 c4 10             	add    $0x10,%esp
     132:	31 c0                	xor    %eax,%eax
     134:	80 3b 00             	cmpb   $0x0,(%ebx)
     137:	0f 94 c0             	sete   %al
}
     13a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if (buf[0] == 0) // EOF
     13d:	f7 d8                	neg    %eax
}
     13f:	5b                   	pop    %ebx
     140:	5e                   	pop    %esi
     141:	5d                   	pop    %ebp
     142:	c3                   	ret    
     143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <panic>:
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     156:	ff 75 08             	pushl  0x8(%ebp)
     159:	68 f3 10 00 00       	push   $0x10f3
     15e:	6a 02                	push   $0x2
     160:	e8 ab 0b 00 00       	call   d10 <printf>
  exit();
     165:	e8 58 0a 00 00       	call   bc2 <exit>
     16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <runcmd>:
{
     170:	55                   	push   %ebp
     171:	89 e5                	mov    %esp,%ebp
     173:	53                   	push   %ebx
     174:	83 ec 14             	sub    $0x14,%esp
     177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (cmd == 0)
     17a:	85 db                	test   %ebx,%ebx
     17c:	74 2d                	je     1ab <runcmd+0x3b>
  switch (cmd->type)
     17e:	8b 03                	mov    (%ebx),%eax
     180:	83 f8 03             	cmp    $0x3,%eax
     183:	0f 84 81 00 00 00    	je     20a <runcmd+0x9a>
     189:	7e 25                	jle    1b0 <runcmd+0x40>
     18b:	83 f8 04             	cmp    $0x4,%eax
     18e:	74 5c                	je     1ec <runcmd+0x7c>
     190:	83 f8 05             	cmp    $0x5,%eax
     193:	75 4a                	jne    1df <runcmd+0x6f>
  pid = fork();
     195:	e8 20 0a 00 00       	call   bba <fork>
  if (pid == -1)
     19a:	83 f8 ff             	cmp    $0xffffffff,%eax
     19d:	0f 84 bc 00 00 00    	je     25f <runcmd+0xef>
    if (fork1() == 0)
     1a3:	85 c0                	test   %eax,%eax
     1a5:	0f 84 ce 00 00 00    	je     279 <runcmd+0x109>
    exit();
     1ab:	e8 12 0a 00 00       	call   bc2 <exit>
  switch (cmd->type)
     1b0:	83 e8 01             	sub    $0x1,%eax
     1b3:	75 2a                	jne    1df <runcmd+0x6f>
    if (ecmd->argv[0] == 0)
     1b5:	8b 43 04             	mov    0x4(%ebx),%eax
     1b8:	85 c0                	test   %eax,%eax
     1ba:	74 ef                	je     1ab <runcmd+0x3b>
    exec(ecmd->argv[0], ecmd->argv);
     1bc:	52                   	push   %edx
     1bd:	52                   	push   %edx
     1be:	8d 53 04             	lea    0x4(%ebx),%edx
     1c1:	52                   	push   %edx
     1c2:	50                   	push   %eax
     1c3:	e8 32 0a 00 00       	call   bfa <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     1c8:	83 c4 0c             	add    $0xc,%esp
     1cb:	ff 73 04             	pushl  0x4(%ebx)
     1ce:	68 72 10 00 00       	push   $0x1072
     1d3:	6a 02                	push   $0x2
     1d5:	e8 36 0b 00 00       	call   d10 <printf>
    break;
     1da:	83 c4 10             	add    $0x10,%esp
     1dd:	eb cc                	jmp    1ab <runcmd+0x3b>
    panic("runcmd");
     1df:	83 ec 0c             	sub    $0xc,%esp
     1e2:	68 6b 10 00 00       	push   $0x106b
     1e7:	e8 64 ff ff ff       	call   150 <panic>
  pid = fork();
     1ec:	e8 c9 09 00 00       	call   bba <fork>
  if (pid == -1)
     1f1:	83 f8 ff             	cmp    $0xffffffff,%eax
     1f4:	74 69                	je     25f <runcmd+0xef>
    if (fork1() == 0)
     1f6:	85 c0                	test   %eax,%eax
     1f8:	74 7f                	je     279 <runcmd+0x109>
    wait();
     1fa:	e8 cb 09 00 00       	call   bca <wait>
    runcmd(lcmd->right);
     1ff:	83 ec 0c             	sub    $0xc,%esp
     202:	ff 73 08             	pushl  0x8(%ebx)
     205:	e8 66 ff ff ff       	call   170 <runcmd>
    if (pipe(p) < 0)
     20a:	8d 45 f0             	lea    -0x10(%ebp),%eax
     20d:	83 ec 0c             	sub    $0xc,%esp
     210:	50                   	push   %eax
     211:	e8 bc 09 00 00       	call   bd2 <pipe>
     216:	83 c4 10             	add    $0x10,%esp
     219:	85 c0                	test   %eax,%eax
     21b:	78 4f                	js     26c <runcmd+0xfc>
  pid = fork();
     21d:	e8 98 09 00 00       	call   bba <fork>
  if (pid == -1)
     222:	83 f8 ff             	cmp    $0xffffffff,%eax
     225:	74 38                	je     25f <runcmd+0xef>
    if (fork1() == 0)
     227:	85 c0                	test   %eax,%eax
     229:	74 59                	je     284 <runcmd+0x114>
  pid = fork();
     22b:	e8 8a 09 00 00       	call   bba <fork>
  if (pid == -1)
     230:	83 f8 ff             	cmp    $0xffffffff,%eax
     233:	74 2a                	je     25f <runcmd+0xef>
    if (fork1() == 0)
     235:	85 c0                	test   %eax,%eax
     237:	74 79                	je     2b2 <runcmd+0x142>
    close(p[0]);
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	ff 75 f0             	pushl  -0x10(%ebp)
     23f:	e8 a6 09 00 00       	call   bea <close>
    close(p[1]);
     244:	58                   	pop    %eax
     245:	ff 75 f4             	pushl  -0xc(%ebp)
     248:	e8 9d 09 00 00       	call   bea <close>
    wait();
     24d:	e8 78 09 00 00       	call   bca <wait>
    wait();
     252:	e8 73 09 00 00       	call   bca <wait>
    break;
     257:	83 c4 10             	add    $0x10,%esp
     25a:	e9 4c ff ff ff       	jmp    1ab <runcmd+0x3b>
    panic("fork");
     25f:	83 ec 0c             	sub    $0xc,%esp
     262:	68 82 10 00 00       	push   $0x1082
     267:	e8 e4 fe ff ff       	call   150 <panic>
      panic("pipe");
     26c:	83 ec 0c             	sub    $0xc,%esp
     26f:	68 87 10 00 00       	push   $0x1087
     274:	e8 d7 fe ff ff       	call   150 <panic>
      runcmd(bcmd->cmd);
     279:	83 ec 0c             	sub    $0xc,%esp
     27c:	ff 73 04             	pushl  0x4(%ebx)
     27f:	e8 ec fe ff ff       	call   170 <runcmd>
      close(1);
     284:	83 ec 0c             	sub    $0xc,%esp
     287:	6a 01                	push   $0x1
     289:	e8 5c 09 00 00       	call   bea <close>
      dup(p[1]);
     28e:	58                   	pop    %eax
     28f:	ff 75 f4             	pushl  -0xc(%ebp)
     292:	e8 a3 09 00 00       	call   c3a <dup>
      close(p[0]);
     297:	58                   	pop    %eax
     298:	ff 75 f0             	pushl  -0x10(%ebp)
     29b:	e8 4a 09 00 00       	call   bea <close>
      close(p[1]);
     2a0:	58                   	pop    %eax
     2a1:	ff 75 f4             	pushl  -0xc(%ebp)
     2a4:	e8 41 09 00 00       	call   bea <close>
      runcmd(pcmd->left);
     2a9:	58                   	pop    %eax
     2aa:	ff 73 04             	pushl  0x4(%ebx)
     2ad:	e8 be fe ff ff       	call   170 <runcmd>
      close(0);
     2b2:	83 ec 0c             	sub    $0xc,%esp
     2b5:	6a 00                	push   $0x0
     2b7:	e8 2e 09 00 00       	call   bea <close>
      dup(p[0]);
     2bc:	5a                   	pop    %edx
     2bd:	ff 75 f0             	pushl  -0x10(%ebp)
     2c0:	e8 75 09 00 00       	call   c3a <dup>
      close(p[0]);
     2c5:	59                   	pop    %ecx
     2c6:	ff 75 f0             	pushl  -0x10(%ebp)
     2c9:	e8 1c 09 00 00       	call   bea <close>
      close(p[1]);
     2ce:	58                   	pop    %eax
     2cf:	ff 75 f4             	pushl  -0xc(%ebp)
     2d2:	e8 13 09 00 00       	call   bea <close>
      runcmd(pcmd->right);
     2d7:	58                   	pop    %eax
     2d8:	ff 73 08             	pushl  0x8(%ebx)
     2db:	e8 90 fe ff ff       	call   170 <runcmd>

000002e0 <fork1>:
{
     2e0:	55                   	push   %ebp
     2e1:	89 e5                	mov    %esp,%ebp
     2e3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     2e6:	e8 cf 08 00 00       	call   bba <fork>
  if (pid == -1)
     2eb:	83 f8 ff             	cmp    $0xffffffff,%eax
     2ee:	74 02                	je     2f2 <fork1+0x12>
  return pid;
}
     2f0:	c9                   	leave  
     2f1:	c3                   	ret    
    panic("fork");
     2f2:	83 ec 0c             	sub    $0xc,%esp
     2f5:	68 82 10 00 00       	push   $0x1082
     2fa:	e8 51 fe ff ff       	call   150 <panic>
     2ff:	90                   	nop

00000300 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd *
execcmd(void)
{
     300:	55                   	push   %ebp
     301:	89 e5                	mov    %esp,%ebp
     303:	53                   	push   %ebx
     304:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     307:	6a 54                	push   $0x54
     309:	e8 62 0c 00 00       	call   f70 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     30e:	83 c4 0c             	add    $0xc,%esp
  cmd = malloc(sizeof(*cmd));
     311:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     313:	6a 54                	push   $0x54
     315:	6a 00                	push   $0x0
     317:	50                   	push   %eax
     318:	e8 03 07 00 00       	call   a20 <memset>
  cmd->type = EXEC;
     31d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd *)cmd;
}
     323:	89 d8                	mov    %ebx,%eax
     325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     328:	c9                   	leave  
     329:	c3                   	ret    
     32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000330 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	53                   	push   %ebx
     334:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     337:	6a 0c                	push   $0xc
     339:	e8 32 0c 00 00       	call   f70 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     33e:	83 c4 0c             	add    $0xc,%esp
  cmd = malloc(sizeof(*cmd));
     341:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     343:	6a 0c                	push   $0xc
     345:	6a 00                	push   $0x0
     347:	50                   	push   %eax
     348:	e8 d3 06 00 00       	call   a20 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     34d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     350:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     356:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     359:	8b 45 0c             	mov    0xc(%ebp),%eax
     35c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd *)cmd;
}
     35f:	89 d8                	mov    %ebx,%eax
     361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     364:	c9                   	leave  
     365:	c3                   	ret    
     366:	8d 76 00             	lea    0x0(%esi),%esi
     369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	53                   	push   %ebx
     374:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     377:	6a 0c                	push   $0xc
     379:	e8 f2 0b 00 00       	call   f70 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     37e:	83 c4 0c             	add    $0xc,%esp
  cmd = malloc(sizeof(*cmd));
     381:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     383:	6a 0c                	push   $0xc
     385:	6a 00                	push   $0x0
     387:	50                   	push   %eax
     388:	e8 93 06 00 00       	call   a20 <memset>
  cmd->type = LIST;
  cmd->left = left;
     38d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     390:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     396:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     399:	8b 45 0c             	mov    0xc(%ebp),%eax
     39c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd *)cmd;
}
     39f:	89 d8                	mov    %ebx,%eax
     3a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3a4:	c9                   	leave  
     3a5:	c3                   	ret    
     3a6:	8d 76 00             	lea    0x0(%esi),%esi
     3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	53                   	push   %ebx
     3b4:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b7:	6a 08                	push   $0x8
     3b9:	e8 b2 0b 00 00       	call   f70 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3be:	83 c4 0c             	add    $0xc,%esp
  cmd = malloc(sizeof(*cmd));
     3c1:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3c3:	6a 08                	push   $0x8
     3c5:	6a 00                	push   $0x0
     3c7:	50                   	push   %eax
     3c8:	e8 53 06 00 00       	call   a20 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     3cd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     3d0:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     3d6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd *)cmd;
}
     3d9:	89 d8                	mov    %ebx,%eax
     3db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3de:	c9                   	leave  
     3df:	c3                   	ret    

000003e0 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	57                   	push   %edi
     3e4:	56                   	push   %esi
     3e5:	53                   	push   %ebx
     3e6:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     3e9:	8b 45 08             	mov    0x8(%ebp),%eax
{
     3ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     3ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  s = *ps;
     3f2:	8b 30                	mov    (%eax),%esi
  while (s < es && strchr(whitespace, *s))
     3f4:	39 de                	cmp    %ebx,%esi
     3f6:	72 0f                	jb     407 <gettoken+0x27>
     3f8:	eb 25                	jmp    41f <gettoken+0x3f>
     3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     400:	83 c6 01             	add    $0x1,%esi
  while (s < es && strchr(whitespace, *s))
     403:	39 f3                	cmp    %esi,%ebx
     405:	74 18                	je     41f <gettoken+0x3f>
     407:	0f be 06             	movsbl (%esi),%eax
     40a:	83 ec 08             	sub    $0x8,%esp
     40d:	50                   	push   %eax
     40e:	68 8c 16 00 00       	push   $0x168c
     413:	e8 28 06 00 00       	call   a40 <strchr>
     418:	83 c4 10             	add    $0x10,%esp
     41b:	85 c0                	test   %eax,%eax
     41d:	75 e1                	jne    400 <gettoken+0x20>
  if (q)
     41f:	85 ff                	test   %edi,%edi
     421:	74 02                	je     425 <gettoken+0x45>
    *q = s;
     423:	89 37                	mov    %esi,(%edi)
  ret = *s;
     425:	0f be 06             	movsbl (%esi),%eax
  switch (*s)
     428:	3c 29                	cmp    $0x29,%al
     42a:	7f 54                	jg     480 <gettoken+0xa0>
     42c:	3c 28                	cmp    $0x28,%al
     42e:	0f 8d c8 00 00 00    	jge    4fc <gettoken+0x11c>
     434:	31 ff                	xor    %edi,%edi
     436:	84 c0                	test   %al,%al
     438:	0f 85 d2 00 00 00    	jne    510 <gettoken+0x130>
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     43e:	8b 55 14             	mov    0x14(%ebp),%edx
     441:	85 d2                	test   %edx,%edx
     443:	74 05                	je     44a <gettoken+0x6a>
    *eq = s;
     445:	8b 45 14             	mov    0x14(%ebp),%eax
     448:	89 30                	mov    %esi,(%eax)

  while (s < es && strchr(whitespace, *s))
     44a:	39 de                	cmp    %ebx,%esi
     44c:	72 09                	jb     457 <gettoken+0x77>
     44e:	eb 1f                	jmp    46f <gettoken+0x8f>
    s++;
     450:	83 c6 01             	add    $0x1,%esi
  while (s < es && strchr(whitespace, *s))
     453:	39 f3                	cmp    %esi,%ebx
     455:	74 18                	je     46f <gettoken+0x8f>
     457:	0f be 06             	movsbl (%esi),%eax
     45a:	83 ec 08             	sub    $0x8,%esp
     45d:	50                   	push   %eax
     45e:	68 8c 16 00 00       	push   $0x168c
     463:	e8 d8 05 00 00       	call   a40 <strchr>
     468:	83 c4 10             	add    $0x10,%esp
     46b:	85 c0                	test   %eax,%eax
     46d:	75 e1                	jne    450 <gettoken+0x70>
  *ps = s;
     46f:	8b 45 08             	mov    0x8(%ebp),%eax
     472:	89 30                	mov    %esi,(%eax)
  return ret;
}
     474:	8d 65 f4             	lea    -0xc(%ebp),%esp
     477:	89 f8                	mov    %edi,%eax
     479:	5b                   	pop    %ebx
     47a:	5e                   	pop    %esi
     47b:	5f                   	pop    %edi
     47c:	5d                   	pop    %ebp
     47d:	c3                   	ret    
     47e:	66 90                	xchg   %ax,%ax
  switch (*s)
     480:	3c 3e                	cmp    $0x3e,%al
     482:	75 1c                	jne    4a0 <gettoken+0xc0>
    if (*s == '>')
     484:	80 7e 01 3e          	cmpb   $0x3e,0x1(%esi)
    s++;
     488:	8d 46 01             	lea    0x1(%esi),%eax
    if (*s == '>')
     48b:	0f 84 a4 00 00 00    	je     535 <gettoken+0x155>
    s++;
     491:	89 c6                	mov    %eax,%esi
     493:	bf 3e 00 00 00       	mov    $0x3e,%edi
     498:	eb a4                	jmp    43e <gettoken+0x5e>
     49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  switch (*s)
     4a0:	7f 56                	jg     4f8 <gettoken+0x118>
     4a2:	8d 48 c5             	lea    -0x3b(%eax),%ecx
     4a5:	80 f9 01             	cmp    $0x1,%cl
     4a8:	76 52                	jbe    4fc <gettoken+0x11c>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4aa:	39 f3                	cmp    %esi,%ebx
     4ac:	77 24                	ja     4d2 <gettoken+0xf2>
     4ae:	eb 70                	jmp    520 <gettoken+0x140>
     4b0:	0f be 06             	movsbl (%esi),%eax
     4b3:	83 ec 08             	sub    $0x8,%esp
     4b6:	50                   	push   %eax
     4b7:	68 84 16 00 00       	push   $0x1684
     4bc:	e8 7f 05 00 00       	call   a40 <strchr>
     4c1:	83 c4 10             	add    $0x10,%esp
     4c4:	85 c0                	test   %eax,%eax
     4c6:	75 1f                	jne    4e7 <gettoken+0x107>
      s++;
     4c8:	83 c6 01             	add    $0x1,%esi
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4cb:	39 f3                	cmp    %esi,%ebx
     4cd:	74 51                	je     520 <gettoken+0x140>
     4cf:	0f be 06             	movsbl (%esi),%eax
     4d2:	83 ec 08             	sub    $0x8,%esp
     4d5:	50                   	push   %eax
     4d6:	68 8c 16 00 00       	push   $0x168c
     4db:	e8 60 05 00 00       	call   a40 <strchr>
     4e0:	83 c4 10             	add    $0x10,%esp
     4e3:	85 c0                	test   %eax,%eax
     4e5:	74 c9                	je     4b0 <gettoken+0xd0>
    ret = 'a';
     4e7:	bf 61 00 00 00       	mov    $0x61,%edi
     4ec:	e9 4d ff ff ff       	jmp    43e <gettoken+0x5e>
     4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch (*s)
     4f8:	3c 7c                	cmp    $0x7c,%al
     4fa:	75 ae                	jne    4aa <gettoken+0xca>
  ret = *s;
     4fc:	0f be f8             	movsbl %al,%edi
    s++;
     4ff:	83 c6 01             	add    $0x1,%esi
    break;
     502:	e9 37 ff ff ff       	jmp    43e <gettoken+0x5e>
     507:	89 f6                	mov    %esi,%esi
     509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  switch (*s)
     510:	3c 26                	cmp    $0x26,%al
     512:	75 96                	jne    4aa <gettoken+0xca>
     514:	eb e6                	jmp    4fc <gettoken+0x11c>
     516:	8d 76 00             	lea    0x0(%esi),%esi
     519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if (eq)
     520:	8b 45 14             	mov    0x14(%ebp),%eax
     523:	bf 61 00 00 00       	mov    $0x61,%edi
     528:	85 c0                	test   %eax,%eax
     52a:	0f 85 15 ff ff ff    	jne    445 <gettoken+0x65>
     530:	e9 3a ff ff ff       	jmp    46f <gettoken+0x8f>
      s++;
     535:	83 c6 02             	add    $0x2,%esi
      ret = '+';
     538:	bf 2b 00 00 00       	mov    $0x2b,%edi
     53d:	e9 fc fe ff ff       	jmp    43e <gettoken+0x5e>
     542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000550 <peek>:

int peek(char **ps, char *es, char *toks)
{
     550:	55                   	push   %ebp
     551:	89 e5                	mov    %esp,%ebp
     553:	57                   	push   %edi
     554:	56                   	push   %esi
     555:	53                   	push   %ebx
     556:	83 ec 0c             	sub    $0xc,%esp
     559:	8b 7d 08             	mov    0x8(%ebp),%edi
     55c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     55f:	8b 1f                	mov    (%edi),%ebx
  while (s < es && strchr(whitespace, *s))
     561:	39 f3                	cmp    %esi,%ebx
     563:	72 12                	jb     577 <peek+0x27>
     565:	eb 28                	jmp    58f <peek+0x3f>
     567:	89 f6                	mov    %esi,%esi
     569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     570:	83 c3 01             	add    $0x1,%ebx
  while (s < es && strchr(whitespace, *s))
     573:	39 de                	cmp    %ebx,%esi
     575:	74 18                	je     58f <peek+0x3f>
     577:	0f be 03             	movsbl (%ebx),%eax
     57a:	83 ec 08             	sub    $0x8,%esp
     57d:	50                   	push   %eax
     57e:	68 8c 16 00 00       	push   $0x168c
     583:	e8 b8 04 00 00       	call   a40 <strchr>
     588:	83 c4 10             	add    $0x10,%esp
     58b:	85 c0                	test   %eax,%eax
     58d:	75 e1                	jne    570 <peek+0x20>
  *ps = s;
     58f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     591:	0f be 13             	movsbl (%ebx),%edx
     594:	31 c0                	xor    %eax,%eax
     596:	84 d2                	test   %dl,%dl
     598:	74 17                	je     5b1 <peek+0x61>
     59a:	83 ec 08             	sub    $0x8,%esp
     59d:	52                   	push   %edx
     59e:	ff 75 10             	pushl  0x10(%ebp)
     5a1:	e8 9a 04 00 00       	call   a40 <strchr>
     5a6:	83 c4 10             	add    $0x10,%esp
     5a9:	85 c0                	test   %eax,%eax
     5ab:	0f 95 c0             	setne  %al
     5ae:	0f b6 c0             	movzbl %al,%eax
}
     5b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5b4:	5b                   	pop    %ebx
     5b5:	5e                   	pop    %esi
     5b6:	5f                   	pop    %edi
     5b7:	5d                   	pop    %ebp
     5b8:	c3                   	ret    
     5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005c0 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     5c0:	55                   	push   %ebp
     5c1:	89 e5                	mov    %esp,%ebp
     5c3:	57                   	push   %edi
     5c4:	56                   	push   %esi
     5c5:	53                   	push   %ebx
  char *q, *eq;

  while (peek(ps, es, "<>"))
  {
    if (gettoken(ps, es, &q, &eq) != 'a')
     5c6:	8d 7d e4             	lea    -0x1c(%ebp),%edi
{
     5c9:	83 ec 1c             	sub    $0x1c,%esp
     5cc:	8b 75 0c             	mov    0xc(%ebp),%esi
     5cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while (peek(ps, es, "<>"))
     5d2:	eb 18                	jmp    5ec <parseredirs+0x2c>
     5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (gettoken(ps, es, &q, &eq) != 'a')
     5d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5db:	57                   	push   %edi
     5dc:	50                   	push   %eax
     5dd:	53                   	push   %ebx
     5de:	56                   	push   %esi
     5df:	e8 fc fd ff ff       	call   3e0 <gettoken>
     5e4:	83 c4 10             	add    $0x10,%esp
     5e7:	83 f8 61             	cmp    $0x61,%eax
     5ea:	75 21                	jne    60d <parseredirs+0x4d>
  while (peek(ps, es, "<>"))
     5ec:	83 ec 04             	sub    $0x4,%esp
     5ef:	68 a9 10 00 00       	push   $0x10a9
     5f4:	53                   	push   %ebx
     5f5:	56                   	push   %esi
     5f6:	e8 55 ff ff ff       	call   550 <peek>
     5fb:	83 c4 10             	add    $0x10,%esp
     5fe:	85 c0                	test   %eax,%eax
     600:	75 d6                	jne    5d8 <parseredirs+0x18>
      panic("missing file for redirection");
  }
  return cmd;
}
     602:	8b 45 08             	mov    0x8(%ebp),%eax
     605:	8d 65 f4             	lea    -0xc(%ebp),%esp
     608:	5b                   	pop    %ebx
     609:	5e                   	pop    %esi
     60a:	5f                   	pop    %edi
     60b:	5d                   	pop    %ebp
     60c:	c3                   	ret    
      panic("missing file for redirection");
     60d:	83 ec 0c             	sub    $0xc,%esp
     610:	68 8c 10 00 00       	push   $0x108c
     615:	e8 36 fb ff ff       	call   150 <panic>
     61a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000620 <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     620:	55                   	push   %ebp
     621:	89 e5                	mov    %esp,%ebp
     623:	57                   	push   %edi
     624:	56                   	push   %esi
     625:	53                   	push   %ebx
     626:	83 ec 30             	sub    $0x30,%esp
     629:	8b 75 08             	mov    0x8(%ebp),%esi
     62c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     62f:	68 ac 10 00 00       	push   $0x10ac
     634:	57                   	push   %edi
     635:	56                   	push   %esi
     636:	e8 15 ff ff ff       	call   550 <peek>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	85 c0                	test   %eax,%eax
     640:	0f 85 92 00 00 00    	jne    6d8 <parseexec+0xb8>
     646:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     648:	e8 b3 fc ff ff       	call   300 <execcmd>
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     64d:	83 ec 04             	sub    $0x4,%esp
  ret = execcmd();
     650:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     653:	57                   	push   %edi
     654:	56                   	push   %esi
     655:	50                   	push   %eax
     656:	e8 65 ff ff ff       	call   5c0 <parseredirs>
     65b:	83 c4 10             	add    $0x10,%esp
     65e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     661:	eb 18                	jmp    67b <parseexec+0x5b>
     663:	90                   	nop
     664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     668:	83 ec 04             	sub    $0x4,%esp
     66b:	57                   	push   %edi
     66c:	56                   	push   %esi
     66d:	ff 75 d4             	pushl  -0x2c(%ebp)
     670:	e8 4b ff ff ff       	call   5c0 <parseredirs>
     675:	83 c4 10             	add    $0x10,%esp
     678:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while (!peek(ps, es, "|)&;"))
     67b:	83 ec 04             	sub    $0x4,%esp
     67e:	68 c3 10 00 00       	push   $0x10c3
     683:	57                   	push   %edi
     684:	56                   	push   %esi
     685:	e8 c6 fe ff ff       	call   550 <peek>
     68a:	83 c4 10             	add    $0x10,%esp
     68d:	85 c0                	test   %eax,%eax
     68f:	75 67                	jne    6f8 <parseexec+0xd8>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     691:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     694:	50                   	push   %eax
     695:	8d 45 e0             	lea    -0x20(%ebp),%eax
     698:	50                   	push   %eax
     699:	57                   	push   %edi
     69a:	56                   	push   %esi
     69b:	e8 40 fd ff ff       	call   3e0 <gettoken>
     6a0:	83 c4 10             	add    $0x10,%esp
     6a3:	85 c0                	test   %eax,%eax
     6a5:	74 51                	je     6f8 <parseexec+0xd8>
    if (tok != 'a')
     6a7:	83 f8 61             	cmp    $0x61,%eax
     6aa:	75 6b                	jne    717 <parseexec+0xf7>
    cmd->argv[argc] = q;
     6ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
     6af:	8b 55 d0             	mov    -0x30(%ebp),%edx
     6b2:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     6b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6b9:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     6bd:	83 c3 01             	add    $0x1,%ebx
    if (argc >= MAXARGS)
     6c0:	83 fb 0a             	cmp    $0xa,%ebx
     6c3:	75 a3                	jne    668 <parseexec+0x48>
      panic("too many args");
     6c5:	83 ec 0c             	sub    $0xc,%esp
     6c8:	68 b5 10 00 00       	push   $0x10b5
     6cd:	e8 7e fa ff ff       	call   150 <panic>
     6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     6d8:	83 ec 08             	sub    $0x8,%esp
     6db:	57                   	push   %edi
     6dc:	56                   	push   %esi
     6dd:	e8 fe 00 00 00       	call   7e0 <parseblock>
     6e2:	83 c4 10             	add    $0x10,%esp
     6e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6ee:	5b                   	pop    %ebx
     6ef:	5e                   	pop    %esi
     6f0:	5f                   	pop    %edi
     6f1:	5d                   	pop    %ebp
     6f2:	c3                   	ret    
     6f3:	90                   	nop
     6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     6f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     6fb:	8d 04 98             	lea    (%eax,%ebx,4),%eax
  cmd->argv[argc] = 0;
     6fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     705:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     70c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     70f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     712:	5b                   	pop    %ebx
     713:	5e                   	pop    %esi
     714:	5f                   	pop    %edi
     715:	5d                   	pop    %ebp
     716:	c3                   	ret    
      panic("syntax");
     717:	83 ec 0c             	sub    $0xc,%esp
     71a:	68 ae 10 00 00       	push   $0x10ae
     71f:	e8 2c fa ff ff       	call   150 <panic>
     724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     72a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000730 <parsepipe>:
{
     730:	55                   	push   %ebp
     731:	89 e5                	mov    %esp,%ebp
}
     733:	5d                   	pop    %ebp
  cmd = parseexec(ps, es);
     734:	e9 e7 fe ff ff       	jmp    620 <parseexec>
     739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000740 <parseline>:
{
     740:	55                   	push   %ebp
     741:	89 e5                	mov    %esp,%ebp
     743:	57                   	push   %edi
     744:	56                   	push   %esi
     745:	53                   	push   %ebx
     746:	83 ec 14             	sub    $0x14,%esp
     749:	8b 5d 08             	mov    0x8(%ebp),%ebx
     74c:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parseexec(ps, es);
     74f:	56                   	push   %esi
     750:	53                   	push   %ebx
     751:	e8 ca fe ff ff       	call   620 <parseexec>
  while (peek(ps, es, "&"))
     756:	83 c4 10             	add    $0x10,%esp
  cmd = parseexec(ps, es);
     759:	89 c7                	mov    %eax,%edi
  while (peek(ps, es, "&"))
     75b:	eb 1b                	jmp    778 <parseline+0x38>
     75d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     760:	6a 00                	push   $0x0
     762:	6a 00                	push   $0x0
     764:	56                   	push   %esi
     765:	53                   	push   %ebx
     766:	e8 75 fc ff ff       	call   3e0 <gettoken>
    cmd = backcmd(cmd);
     76b:	89 3c 24             	mov    %edi,(%esp)
     76e:	e8 3d fc ff ff       	call   3b0 <backcmd>
     773:	83 c4 10             	add    $0x10,%esp
     776:	89 c7                	mov    %eax,%edi
  while (peek(ps, es, "&"))
     778:	83 ec 04             	sub    $0x4,%esp
     77b:	68 c8 10 00 00       	push   $0x10c8
     780:	56                   	push   %esi
     781:	53                   	push   %ebx
     782:	e8 c9 fd ff ff       	call   550 <peek>
     787:	83 c4 10             	add    $0x10,%esp
     78a:	85 c0                	test   %eax,%eax
     78c:	75 d2                	jne    760 <parseline+0x20>
  if (peek(ps, es, ";"))
     78e:	83 ec 04             	sub    $0x4,%esp
     791:	68 c6 10 00 00       	push   $0x10c6
     796:	56                   	push   %esi
     797:	53                   	push   %ebx
     798:	e8 b3 fd ff ff       	call   550 <peek>
     79d:	83 c4 10             	add    $0x10,%esp
     7a0:	85 c0                	test   %eax,%eax
     7a2:	75 0c                	jne    7b0 <parseline+0x70>
}
     7a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7a7:	89 f8                	mov    %edi,%eax
     7a9:	5b                   	pop    %ebx
     7aa:	5e                   	pop    %esi
     7ab:	5f                   	pop    %edi
     7ac:	5d                   	pop    %ebp
     7ad:	c3                   	ret    
     7ae:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     7b0:	6a 00                	push   $0x0
     7b2:	6a 00                	push   $0x0
     7b4:	56                   	push   %esi
     7b5:	53                   	push   %ebx
     7b6:	e8 25 fc ff ff       	call   3e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     7bb:	58                   	pop    %eax
     7bc:	5a                   	pop    %edx
     7bd:	56                   	push   %esi
     7be:	53                   	push   %ebx
     7bf:	e8 7c ff ff ff       	call   740 <parseline>
     7c4:	89 7d 08             	mov    %edi,0x8(%ebp)
     7c7:	89 45 0c             	mov    %eax,0xc(%ebp)
     7ca:	83 c4 10             	add    $0x10,%esp
}
     7cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7d0:	5b                   	pop    %ebx
     7d1:	5e                   	pop    %esi
     7d2:	5f                   	pop    %edi
     7d3:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     7d4:	e9 97 fb ff ff       	jmp    370 <listcmd>
     7d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007e0 <parseblock>:
{
     7e0:	55                   	push   %ebp
     7e1:	89 e5                	mov    %esp,%ebp
     7e3:	57                   	push   %edi
     7e4:	56                   	push   %esi
     7e5:	53                   	push   %ebx
     7e6:	83 ec 10             	sub    $0x10,%esp
     7e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     7ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (!peek(ps, es, "("))
     7ef:	68 ac 10 00 00       	push   $0x10ac
     7f4:	56                   	push   %esi
     7f5:	53                   	push   %ebx
     7f6:	e8 55 fd ff ff       	call   550 <peek>
     7fb:	83 c4 10             	add    $0x10,%esp
     7fe:	85 c0                	test   %eax,%eax
     800:	74 4a                	je     84c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     802:	6a 00                	push   $0x0
     804:	6a 00                	push   $0x0
     806:	56                   	push   %esi
     807:	53                   	push   %ebx
     808:	e8 d3 fb ff ff       	call   3e0 <gettoken>
  cmd = parseline(ps, es);
     80d:	58                   	pop    %eax
     80e:	5a                   	pop    %edx
     80f:	56                   	push   %esi
     810:	53                   	push   %ebx
     811:	e8 2a ff ff ff       	call   740 <parseline>
  if (!peek(ps, es, ")"))
     816:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(ps, es);
     819:	89 c7                	mov    %eax,%edi
  if (!peek(ps, es, ")"))
     81b:	68 e6 10 00 00       	push   $0x10e6
     820:	56                   	push   %esi
     821:	53                   	push   %ebx
     822:	e8 29 fd ff ff       	call   550 <peek>
     827:	83 c4 10             	add    $0x10,%esp
     82a:	85 c0                	test   %eax,%eax
     82c:	74 2b                	je     859 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     82e:	6a 00                	push   $0x0
     830:	6a 00                	push   $0x0
     832:	56                   	push   %esi
     833:	53                   	push   %ebx
     834:	e8 a7 fb ff ff       	call   3e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     839:	83 c4 0c             	add    $0xc,%esp
     83c:	56                   	push   %esi
     83d:	53                   	push   %ebx
     83e:	57                   	push   %edi
     83f:	e8 7c fd ff ff       	call   5c0 <parseredirs>
}
     844:	8d 65 f4             	lea    -0xc(%ebp),%esp
     847:	5b                   	pop    %ebx
     848:	5e                   	pop    %esi
     849:	5f                   	pop    %edi
     84a:	5d                   	pop    %ebp
     84b:	c3                   	ret    
    panic("parseblock");
     84c:	83 ec 0c             	sub    $0xc,%esp
     84f:	68 ca 10 00 00       	push   $0x10ca
     854:	e8 f7 f8 ff ff       	call   150 <panic>
    panic("syntax - missing )");
     859:	83 ec 0c             	sub    $0xc,%esp
     85c:	68 d5 10 00 00       	push   $0x10d5
     861:	e8 ea f8 ff ff       	call   150 <panic>
     866:	8d 76 00             	lea    0x0(%esi),%esi
     869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000870 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     870:	55                   	push   %ebp
     871:	89 e5                	mov    %esp,%ebp
     873:	53                   	push   %ebx
     874:	83 ec 04             	sub    $0x4,%esp
     877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;

  if (cmd == 0)
     87a:	85 db                	test   %ebx,%ebx
     87c:	74 21                	je     89f <nulterminate+0x2f>
    return 0;

  switch (cmd->type)
     87e:	8b 03                	mov    (%ebx),%eax
     880:	83 f8 03             	cmp    $0x3,%eax
     883:	74 5b                	je     8e0 <nulterminate+0x70>
     885:	7e 29                	jle    8b0 <nulterminate+0x40>
     887:	83 f8 04             	cmp    $0x4,%eax
     88a:	74 54                	je     8e0 <nulterminate+0x70>
     88c:	83 f8 05             	cmp    $0x5,%eax
     88f:	75 0e                	jne    89f <nulterminate+0x2f>
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
     891:	83 ec 0c             	sub    $0xc,%esp
     894:	ff 73 04             	pushl  0x4(%ebx)
     897:	e8 d4 ff ff ff       	call   870 <nulterminate>
    break;
     89c:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     89f:	89 d8                	mov    %ebx,%eax
     8a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8a4:	c9                   	leave  
     8a5:	c3                   	ret    
     8a6:	8d 76 00             	lea    0x0(%esi),%esi
     8a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  switch (cmd->type)
     8b0:	83 f8 01             	cmp    $0x1,%eax
     8b3:	75 ea                	jne    89f <nulterminate+0x2f>
    for (i = 0; ecmd->argv[i]; i++)
     8b5:	8b 4b 04             	mov    0x4(%ebx),%ecx
     8b8:	8d 43 08             	lea    0x8(%ebx),%eax
     8bb:	85 c9                	test   %ecx,%ecx
     8bd:	74 e0                	je     89f <nulterminate+0x2f>
     8bf:	90                   	nop
      *ecmd->eargv[i] = 0;
     8c0:	8b 50 24             	mov    0x24(%eax),%edx
     8c3:	83 c0 04             	add    $0x4,%eax
     8c6:	c6 02 00             	movb   $0x0,(%edx)
    for (i = 0; ecmd->argv[i]; i++)
     8c9:	8b 50 fc             	mov    -0x4(%eax),%edx
     8cc:	85 d2                	test   %edx,%edx
     8ce:	75 f0                	jne    8c0 <nulterminate+0x50>
}
     8d0:	89 d8                	mov    %ebx,%eax
     8d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8d5:	c9                   	leave  
     8d6:	c3                   	ret    
     8d7:	89 f6                	mov    %esi,%esi
     8d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    nulterminate(lcmd->left);
     8e0:	83 ec 0c             	sub    $0xc,%esp
     8e3:	ff 73 04             	pushl  0x4(%ebx)
     8e6:	e8 85 ff ff ff       	call   870 <nulterminate>
    nulterminate(lcmd->right);
     8eb:	58                   	pop    %eax
     8ec:	ff 73 08             	pushl  0x8(%ebx)
     8ef:	e8 7c ff ff ff       	call   870 <nulterminate>
}
     8f4:	89 d8                	mov    %ebx,%eax
    break;
     8f6:	83 c4 10             	add    $0x10,%esp
}
     8f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8fc:	c9                   	leave  
     8fd:	c3                   	ret    
     8fe:	66 90                	xchg   %ax,%ax

00000900 <parsecmd>:
{
     900:	55                   	push   %ebp
     901:	89 e5                	mov    %esp,%ebp
     903:	56                   	push   %esi
     904:	53                   	push   %ebx
  es = s + strlen(s);
     905:	8b 5d 08             	mov    0x8(%ebp),%ebx
     908:	83 ec 0c             	sub    $0xc,%esp
     90b:	53                   	push   %ebx
     90c:	e8 df 00 00 00       	call   9f0 <strlen>
  cmd = parseline(&s, es);
     911:	59                   	pop    %ecx
  es = s + strlen(s);
     912:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     914:	8d 45 08             	lea    0x8(%ebp),%eax
     917:	5e                   	pop    %esi
     918:	53                   	push   %ebx
     919:	50                   	push   %eax
     91a:	e8 21 fe ff ff       	call   740 <parseline>
     91f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     921:	8d 45 08             	lea    0x8(%ebp),%eax
     924:	83 c4 0c             	add    $0xc,%esp
     927:	68 81 10 00 00       	push   $0x1081
     92c:	53                   	push   %ebx
     92d:	50                   	push   %eax
     92e:	e8 1d fc ff ff       	call   550 <peek>
  if (s != es)
     933:	8b 45 08             	mov    0x8(%ebp),%eax
     936:	83 c4 10             	add    $0x10,%esp
     939:	39 d8                	cmp    %ebx,%eax
     93b:	75 12                	jne    94f <parsecmd+0x4f>
  nulterminate(cmd);
     93d:	83 ec 0c             	sub    $0xc,%esp
     940:	56                   	push   %esi
     941:	e8 2a ff ff ff       	call   870 <nulterminate>
}
     946:	8d 65 f8             	lea    -0x8(%ebp),%esp
     949:	89 f0                	mov    %esi,%eax
     94b:	5b                   	pop    %ebx
     94c:	5e                   	pop    %esi
     94d:	5d                   	pop    %ebp
     94e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     94f:	52                   	push   %edx
     950:	50                   	push   %eax
     951:	68 e8 10 00 00       	push   $0x10e8
     956:	6a 02                	push   $0x2
     958:	e8 b3 03 00 00       	call   d10 <printf>
    panic("syntax");
     95d:	c7 04 24 ae 10 00 00 	movl   $0x10ae,(%esp)
     964:	e8 e7 f7 ff ff       	call   150 <panic>
     969:	66 90                	xchg   %ax,%ax
     96b:	66 90                	xchg   %ax,%ax
     96d:	66 90                	xchg   %ax,%ax
     96f:	90                   	nop

00000970 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	53                   	push   %ebx
     974:	8b 45 08             	mov    0x8(%ebp),%eax
     977:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     97a:	89 c2                	mov    %eax,%edx
     97c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     980:	83 c1 01             	add    $0x1,%ecx
     983:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     987:	83 c2 01             	add    $0x1,%edx
     98a:	84 db                	test   %bl,%bl
     98c:	88 5a ff             	mov    %bl,-0x1(%edx)
     98f:	75 ef                	jne    980 <strcpy+0x10>
    ;
  return os;
}
     991:	5b                   	pop    %ebx
     992:	5d                   	pop    %ebp
     993:	c3                   	ret    
     994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     99a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000009a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9a0:	55                   	push   %ebp
     9a1:	89 e5                	mov    %esp,%ebp
     9a3:	53                   	push   %ebx
     9a4:	8b 55 08             	mov    0x8(%ebp),%edx
     9a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     9aa:	0f b6 02             	movzbl (%edx),%eax
     9ad:	0f b6 19             	movzbl (%ecx),%ebx
     9b0:	84 c0                	test   %al,%al
     9b2:	75 1c                	jne    9d0 <strcmp+0x30>
     9b4:	eb 2a                	jmp    9e0 <strcmp+0x40>
     9b6:	8d 76 00             	lea    0x0(%esi),%esi
     9b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     9c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     9c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     9c6:	83 c1 01             	add    $0x1,%ecx
     9c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     9cc:	84 c0                	test   %al,%al
     9ce:	74 10                	je     9e0 <strcmp+0x40>
     9d0:	38 d8                	cmp    %bl,%al
     9d2:	74 ec                	je     9c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     9d4:	29 d8                	sub    %ebx,%eax
}
     9d6:	5b                   	pop    %ebx
     9d7:	5d                   	pop    %ebp
     9d8:	c3                   	ret    
     9d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     9e2:	29 d8                	sub    %ebx,%eax
}
     9e4:	5b                   	pop    %ebx
     9e5:	5d                   	pop    %ebp
     9e6:	c3                   	ret    
     9e7:	89 f6                	mov    %esi,%esi
     9e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009f0 <strlen>:

uint
strlen(const char *s)
{
     9f0:	55                   	push   %ebp
     9f1:	89 e5                	mov    %esp,%ebp
     9f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     9f6:	80 39 00             	cmpb   $0x0,(%ecx)
     9f9:	74 15                	je     a10 <strlen+0x20>
     9fb:	31 d2                	xor    %edx,%edx
     9fd:	8d 76 00             	lea    0x0(%esi),%esi
     a00:	83 c2 01             	add    $0x1,%edx
     a03:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     a07:	89 d0                	mov    %edx,%eax
     a09:	75 f5                	jne    a00 <strlen+0x10>
    ;
  return n;
}
     a0b:	5d                   	pop    %ebp
     a0c:	c3                   	ret    
     a0d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     a10:	31 c0                	xor    %eax,%eax
}
     a12:	5d                   	pop    %ebp
     a13:	c3                   	ret    
     a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a20 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	57                   	push   %edi
     a24:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a27:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a2d:	89 d7                	mov    %edx,%edi
     a2f:	fc                   	cld    
     a30:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     a32:	89 d0                	mov    %edx,%eax
     a34:	5f                   	pop    %edi
     a35:	5d                   	pop    %ebp
     a36:	c3                   	ret    
     a37:	89 f6                	mov    %esi,%esi
     a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a40 <strchr>:

char*
strchr(const char *s, char c)
{
     a40:	55                   	push   %ebp
     a41:	89 e5                	mov    %esp,%ebp
     a43:	53                   	push   %ebx
     a44:	8b 45 08             	mov    0x8(%ebp),%eax
     a47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     a4a:	0f b6 10             	movzbl (%eax),%edx
     a4d:	84 d2                	test   %dl,%dl
     a4f:	74 1d                	je     a6e <strchr+0x2e>
    if(*s == c)
     a51:	38 d3                	cmp    %dl,%bl
     a53:	89 d9                	mov    %ebx,%ecx
     a55:	75 0d                	jne    a64 <strchr+0x24>
     a57:	eb 17                	jmp    a70 <strchr+0x30>
     a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a60:	38 ca                	cmp    %cl,%dl
     a62:	74 0c                	je     a70 <strchr+0x30>
  for(; *s; s++)
     a64:	83 c0 01             	add    $0x1,%eax
     a67:	0f b6 10             	movzbl (%eax),%edx
     a6a:	84 d2                	test   %dl,%dl
     a6c:	75 f2                	jne    a60 <strchr+0x20>
      return (char*)s;
  return 0;
     a6e:	31 c0                	xor    %eax,%eax
}
     a70:	5b                   	pop    %ebx
     a71:	5d                   	pop    %ebp
     a72:	c3                   	ret    
     a73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a80 <gets>:

char*
gets(char *buf, int max)
{
     a80:	55                   	push   %ebp
     a81:	89 e5                	mov    %esp,%ebp
     a83:	57                   	push   %edi
     a84:	56                   	push   %esi
     a85:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a86:	31 f6                	xor    %esi,%esi
     a88:	89 f3                	mov    %esi,%ebx
{
     a8a:	83 ec 1c             	sub    $0x1c,%esp
     a8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     a90:	eb 2f                	jmp    ac1 <gets+0x41>
     a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     a98:	8d 45 e7             	lea    -0x19(%ebp),%eax
     a9b:	83 ec 04             	sub    $0x4,%esp
     a9e:	6a 01                	push   $0x1
     aa0:	50                   	push   %eax
     aa1:	6a 00                	push   $0x0
     aa3:	e8 32 01 00 00       	call   bda <read>
    if(cc < 1)
     aa8:	83 c4 10             	add    $0x10,%esp
     aab:	85 c0                	test   %eax,%eax
     aad:	7e 1c                	jle    acb <gets+0x4b>
      break;
    buf[i++] = c;
     aaf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ab3:	83 c7 01             	add    $0x1,%edi
     ab6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     ab9:	3c 0a                	cmp    $0xa,%al
     abb:	74 23                	je     ae0 <gets+0x60>
     abd:	3c 0d                	cmp    $0xd,%al
     abf:	74 1f                	je     ae0 <gets+0x60>
  for(i=0; i+1 < max; ){
     ac1:	83 c3 01             	add    $0x1,%ebx
     ac4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     ac7:	89 fe                	mov    %edi,%esi
     ac9:	7c cd                	jl     a98 <gets+0x18>
     acb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     acd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     ad0:	c6 03 00             	movb   $0x0,(%ebx)
}
     ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ad6:	5b                   	pop    %ebx
     ad7:	5e                   	pop    %esi
     ad8:	5f                   	pop    %edi
     ad9:	5d                   	pop    %ebp
     ada:	c3                   	ret    
     adb:	90                   	nop
     adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ae0:	8b 75 08             	mov    0x8(%ebp),%esi
     ae3:	8b 45 08             	mov    0x8(%ebp),%eax
     ae6:	01 de                	add    %ebx,%esi
     ae8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     aea:	c6 03 00             	movb   $0x0,(%ebx)
}
     aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
     af0:	5b                   	pop    %ebx
     af1:	5e                   	pop    %esi
     af2:	5f                   	pop    %edi
     af3:	5d                   	pop    %ebp
     af4:	c3                   	ret    
     af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b00 <stat>:

int
stat(const char *n, struct stat *st)
{
     b00:	55                   	push   %ebp
     b01:	89 e5                	mov    %esp,%ebp
     b03:	56                   	push   %esi
     b04:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b05:	83 ec 08             	sub    $0x8,%esp
     b08:	6a 00                	push   $0x0
     b0a:	ff 75 08             	pushl  0x8(%ebp)
     b0d:	e8 f0 00 00 00       	call   c02 <open>
  if(fd < 0)
     b12:	83 c4 10             	add    $0x10,%esp
     b15:	85 c0                	test   %eax,%eax
     b17:	78 27                	js     b40 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     b19:	83 ec 08             	sub    $0x8,%esp
     b1c:	ff 75 0c             	pushl  0xc(%ebp)
     b1f:	89 c3                	mov    %eax,%ebx
     b21:	50                   	push   %eax
     b22:	e8 f3 00 00 00       	call   c1a <fstat>
  close(fd);
     b27:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     b2a:	89 c6                	mov    %eax,%esi
  close(fd);
     b2c:	e8 b9 00 00 00       	call   bea <close>
  return r;
     b31:	83 c4 10             	add    $0x10,%esp
}
     b34:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b37:	89 f0                	mov    %esi,%eax
     b39:	5b                   	pop    %ebx
     b3a:	5e                   	pop    %esi
     b3b:	5d                   	pop    %ebp
     b3c:	c3                   	ret    
     b3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     b40:	be ff ff ff ff       	mov    $0xffffffff,%esi
     b45:	eb ed                	jmp    b34 <stat+0x34>
     b47:	89 f6                	mov    %esi,%esi
     b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b50 <atoi>:

int
atoi(const char *s)
{
     b50:	55                   	push   %ebp
     b51:	89 e5                	mov    %esp,%ebp
     b53:	53                   	push   %ebx
     b54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b57:	0f be 11             	movsbl (%ecx),%edx
     b5a:	8d 42 d0             	lea    -0x30(%edx),%eax
     b5d:	3c 09                	cmp    $0x9,%al
  n = 0;
     b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     b64:	77 1f                	ja     b85 <atoi+0x35>
     b66:	8d 76 00             	lea    0x0(%esi),%esi
     b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     b70:	8d 04 80             	lea    (%eax,%eax,4),%eax
     b73:	83 c1 01             	add    $0x1,%ecx
     b76:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     b7a:	0f be 11             	movsbl (%ecx),%edx
     b7d:	8d 5a d0             	lea    -0x30(%edx),%ebx
     b80:	80 fb 09             	cmp    $0x9,%bl
     b83:	76 eb                	jbe    b70 <atoi+0x20>
  return n;
}
     b85:	5b                   	pop    %ebx
     b86:	5d                   	pop    %ebp
     b87:	c3                   	ret    
     b88:	90                   	nop
     b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000b90 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b90:	55                   	push   %ebp
     b91:	89 e5                	mov    %esp,%ebp
     b93:	56                   	push   %esi
     b94:	53                   	push   %ebx
     b95:	8b 5d 10             	mov    0x10(%ebp),%ebx
     b98:	8b 45 08             	mov    0x8(%ebp),%eax
     b9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     b9e:	85 db                	test   %ebx,%ebx
     ba0:	7e 14                	jle    bb6 <memmove+0x26>
     ba2:	31 d2                	xor    %edx,%edx
     ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     ba8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     bac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     baf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     bb2:	39 d3                	cmp    %edx,%ebx
     bb4:	75 f2                	jne    ba8 <memmove+0x18>
  return vdst;
}
     bb6:	5b                   	pop    %ebx
     bb7:	5e                   	pop    %esi
     bb8:	5d                   	pop    %ebp
     bb9:	c3                   	ret    

00000bba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     bba:	b8 01 00 00 00       	mov    $0x1,%eax
     bbf:	cd 40                	int    $0x40
     bc1:	c3                   	ret    

00000bc2 <exit>:
SYSCALL(exit)
     bc2:	b8 02 00 00 00       	mov    $0x2,%eax
     bc7:	cd 40                	int    $0x40
     bc9:	c3                   	ret    

00000bca <wait>:
SYSCALL(wait)
     bca:	b8 03 00 00 00       	mov    $0x3,%eax
     bcf:	cd 40                	int    $0x40
     bd1:	c3                   	ret    

00000bd2 <pipe>:
SYSCALL(pipe)
     bd2:	b8 04 00 00 00       	mov    $0x4,%eax
     bd7:	cd 40                	int    $0x40
     bd9:	c3                   	ret    

00000bda <read>:
SYSCALL(read)
     bda:	b8 05 00 00 00       	mov    $0x5,%eax
     bdf:	cd 40                	int    $0x40
     be1:	c3                   	ret    

00000be2 <write>:
SYSCALL(write)
     be2:	b8 10 00 00 00       	mov    $0x10,%eax
     be7:	cd 40                	int    $0x40
     be9:	c3                   	ret    

00000bea <close>:
SYSCALL(close)
     bea:	b8 15 00 00 00       	mov    $0x15,%eax
     bef:	cd 40                	int    $0x40
     bf1:	c3                   	ret    

00000bf2 <kill>:
SYSCALL(kill)
     bf2:	b8 06 00 00 00       	mov    $0x6,%eax
     bf7:	cd 40                	int    $0x40
     bf9:	c3                   	ret    

00000bfa <exec>:
SYSCALL(exec)
     bfa:	b8 07 00 00 00       	mov    $0x7,%eax
     bff:	cd 40                	int    $0x40
     c01:	c3                   	ret    

00000c02 <open>:
SYSCALL(open)
     c02:	b8 0f 00 00 00       	mov    $0xf,%eax
     c07:	cd 40                	int    $0x40
     c09:	c3                   	ret    

00000c0a <mknod>:
SYSCALL(mknod)
     c0a:	b8 11 00 00 00       	mov    $0x11,%eax
     c0f:	cd 40                	int    $0x40
     c11:	c3                   	ret    

00000c12 <unlink>:
SYSCALL(unlink)
     c12:	b8 12 00 00 00       	mov    $0x12,%eax
     c17:	cd 40                	int    $0x40
     c19:	c3                   	ret    

00000c1a <fstat>:
SYSCALL(fstat)
     c1a:	b8 08 00 00 00       	mov    $0x8,%eax
     c1f:	cd 40                	int    $0x40
     c21:	c3                   	ret    

00000c22 <link>:
SYSCALL(link)
     c22:	b8 13 00 00 00       	mov    $0x13,%eax
     c27:	cd 40                	int    $0x40
     c29:	c3                   	ret    

00000c2a <mkdir>:
SYSCALL(mkdir)
     c2a:	b8 14 00 00 00       	mov    $0x14,%eax
     c2f:	cd 40                	int    $0x40
     c31:	c3                   	ret    

00000c32 <chdir>:
SYSCALL(chdir)
     c32:	b8 09 00 00 00       	mov    $0x9,%eax
     c37:	cd 40                	int    $0x40
     c39:	c3                   	ret    

00000c3a <dup>:
SYSCALL(dup)
     c3a:	b8 0a 00 00 00       	mov    $0xa,%eax
     c3f:	cd 40                	int    $0x40
     c41:	c3                   	ret    

00000c42 <getpid>:
SYSCALL(getpid)
     c42:	b8 0b 00 00 00       	mov    $0xb,%eax
     c47:	cd 40                	int    $0x40
     c49:	c3                   	ret    

00000c4a <sbrk>:
SYSCALL(sbrk)
     c4a:	b8 0c 00 00 00       	mov    $0xc,%eax
     c4f:	cd 40                	int    $0x40
     c51:	c3                   	ret    

00000c52 <sleep>:
SYSCALL(sleep)
     c52:	b8 0d 00 00 00       	mov    $0xd,%eax
     c57:	cd 40                	int    $0x40
     c59:	c3                   	ret    

00000c5a <uptime>:
SYSCALL(uptime)
     c5a:	b8 0e 00 00 00       	mov    $0xe,%eax
     c5f:	cd 40                	int    $0x40
     c61:	c3                   	ret    

00000c62 <cps>:
SYSCALL(cps)
     c62:	b8 16 00 00 00       	mov    $0x16,%eax
     c67:	cd 40                	int    $0x40
     c69:	c3                   	ret    
     c6a:	66 90                	xchg   %ax,%ax
     c6c:	66 90                	xchg   %ax,%ax
     c6e:	66 90                	xchg   %ax,%ax

00000c70 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	57                   	push   %edi
     c74:	56                   	push   %esi
     c75:	53                   	push   %ebx
     c76:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c79:	85 d2                	test   %edx,%edx
{
     c7b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
     c7e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
     c80:	79 76                	jns    cf8 <printint+0x88>
     c82:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     c86:	74 70                	je     cf8 <printint+0x88>
    x = -xx;
     c88:	f7 d8                	neg    %eax
    neg = 1;
     c8a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     c91:	31 f6                	xor    %esi,%esi
     c93:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     c96:	eb 0a                	jmp    ca2 <printint+0x32>
     c98:	90                   	nop
     c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
     ca0:	89 fe                	mov    %edi,%esi
     ca2:	31 d2                	xor    %edx,%edx
     ca4:	8d 7e 01             	lea    0x1(%esi),%edi
     ca7:	f7 f1                	div    %ecx
     ca9:	0f b6 92 14 11 00 00 	movzbl 0x1114(%edx),%edx
  }while((x /= base) != 0);
     cb0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
     cb2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
     cb5:	75 e9                	jne    ca0 <printint+0x30>
  if(neg)
     cb7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     cba:	85 c0                	test   %eax,%eax
     cbc:	74 08                	je     cc6 <printint+0x56>
    buf[i++] = '-';
     cbe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     cc3:	8d 7e 02             	lea    0x2(%esi),%edi
     cc6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
     cca:	8b 7d c0             	mov    -0x40(%ebp),%edi
     ccd:	8d 76 00             	lea    0x0(%esi),%esi
     cd0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
     cd3:	83 ec 04             	sub    $0x4,%esp
     cd6:	83 ee 01             	sub    $0x1,%esi
     cd9:	6a 01                	push   $0x1
     cdb:	53                   	push   %ebx
     cdc:	57                   	push   %edi
     cdd:	88 45 d7             	mov    %al,-0x29(%ebp)
     ce0:	e8 fd fe ff ff       	call   be2 <write>

  while(--i >= 0)
     ce5:	83 c4 10             	add    $0x10,%esp
     ce8:	39 de                	cmp    %ebx,%esi
     cea:	75 e4                	jne    cd0 <printint+0x60>
    putc(fd, buf[i]);
}
     cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cef:	5b                   	pop    %ebx
     cf0:	5e                   	pop    %esi
     cf1:	5f                   	pop    %edi
     cf2:	5d                   	pop    %ebp
     cf3:	c3                   	ret    
     cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     cf8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     cff:	eb 90                	jmp    c91 <printint+0x21>
     d01:	eb 0d                	jmp    d10 <printf>
     d03:	90                   	nop
     d04:	90                   	nop
     d05:	90                   	nop
     d06:	90                   	nop
     d07:	90                   	nop
     d08:	90                   	nop
     d09:	90                   	nop
     d0a:	90                   	nop
     d0b:	90                   	nop
     d0c:	90                   	nop
     d0d:	90                   	nop
     d0e:	90                   	nop
     d0f:	90                   	nop

00000d10 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     d10:	55                   	push   %ebp
     d11:	89 e5                	mov    %esp,%ebp
     d13:	57                   	push   %edi
     d14:	56                   	push   %esi
     d15:	53                   	push   %ebx
     d16:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     d19:	8b 75 0c             	mov    0xc(%ebp),%esi
     d1c:	0f b6 1e             	movzbl (%esi),%ebx
     d1f:	84 db                	test   %bl,%bl
     d21:	0f 84 b3 00 00 00    	je     dda <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
     d27:	8d 45 10             	lea    0x10(%ebp),%eax
     d2a:	83 c6 01             	add    $0x1,%esi
  state = 0;
     d2d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
     d2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     d32:	eb 2f                	jmp    d63 <printf+0x53>
     d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     d38:	83 f8 25             	cmp    $0x25,%eax
     d3b:	0f 84 a7 00 00 00    	je     de8 <printf+0xd8>
  write(fd, &c, 1);
     d41:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     d44:	83 ec 04             	sub    $0x4,%esp
     d47:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     d4a:	6a 01                	push   $0x1
     d4c:	50                   	push   %eax
     d4d:	ff 75 08             	pushl  0x8(%ebp)
     d50:	e8 8d fe ff ff       	call   be2 <write>
     d55:	83 c4 10             	add    $0x10,%esp
     d58:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     d5b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     d5f:	84 db                	test   %bl,%bl
     d61:	74 77                	je     dda <printf+0xca>
    if(state == 0){
     d63:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
     d65:	0f be cb             	movsbl %bl,%ecx
     d68:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     d6b:	74 cb                	je     d38 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d6d:	83 ff 25             	cmp    $0x25,%edi
     d70:	75 e6                	jne    d58 <printf+0x48>
      if(c == 'd'){
     d72:	83 f8 64             	cmp    $0x64,%eax
     d75:	0f 84 05 01 00 00    	je     e80 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     d7b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     d81:	83 f9 70             	cmp    $0x70,%ecx
     d84:	74 72                	je     df8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     d86:	83 f8 73             	cmp    $0x73,%eax
     d89:	0f 84 99 00 00 00    	je     e28 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     d8f:	83 f8 63             	cmp    $0x63,%eax
     d92:	0f 84 08 01 00 00    	je     ea0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     d98:	83 f8 25             	cmp    $0x25,%eax
     d9b:	0f 84 ef 00 00 00    	je     e90 <printf+0x180>
  write(fd, &c, 1);
     da1:	8d 45 e7             	lea    -0x19(%ebp),%eax
     da4:	83 ec 04             	sub    $0x4,%esp
     da7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     dab:	6a 01                	push   $0x1
     dad:	50                   	push   %eax
     dae:	ff 75 08             	pushl  0x8(%ebp)
     db1:	e8 2c fe ff ff       	call   be2 <write>
     db6:	83 c4 0c             	add    $0xc,%esp
     db9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     dbc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     dbf:	6a 01                	push   $0x1
     dc1:	50                   	push   %eax
     dc2:	ff 75 08             	pushl  0x8(%ebp)
     dc5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     dc8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
     dca:	e8 13 fe ff ff       	call   be2 <write>
  for(i = 0; fmt[i]; i++){
     dcf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
     dd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     dd6:	84 db                	test   %bl,%bl
     dd8:	75 89                	jne    d63 <printf+0x53>
    }
  }
}
     dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ddd:	5b                   	pop    %ebx
     dde:	5e                   	pop    %esi
     ddf:	5f                   	pop    %edi
     de0:	5d                   	pop    %ebp
     de1:	c3                   	ret    
     de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
     de8:	bf 25 00 00 00       	mov    $0x25,%edi
     ded:	e9 66 ff ff ff       	jmp    d58 <printf+0x48>
     df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
     df8:	83 ec 0c             	sub    $0xc,%esp
     dfb:	b9 10 00 00 00       	mov    $0x10,%ecx
     e00:	6a 00                	push   $0x0
     e02:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     e05:	8b 45 08             	mov    0x8(%ebp),%eax
     e08:	8b 17                	mov    (%edi),%edx
     e0a:	e8 61 fe ff ff       	call   c70 <printint>
        ap++;
     e0f:	89 f8                	mov    %edi,%eax
     e11:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e14:	31 ff                	xor    %edi,%edi
        ap++;
     e16:	83 c0 04             	add    $0x4,%eax
     e19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e1c:	e9 37 ff ff ff       	jmp    d58 <printf+0x48>
     e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
     e28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     e2b:	8b 08                	mov    (%eax),%ecx
        ap++;
     e2d:	83 c0 04             	add    $0x4,%eax
     e30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
     e33:	85 c9                	test   %ecx,%ecx
     e35:	0f 84 8e 00 00 00    	je     ec9 <printf+0x1b9>
        while(*s != 0){
     e3b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
     e3e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
     e40:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
     e42:	84 c0                	test   %al,%al
     e44:	0f 84 0e ff ff ff    	je     d58 <printf+0x48>
     e4a:	89 75 d0             	mov    %esi,-0x30(%ebp)
     e4d:	89 de                	mov    %ebx,%esi
     e4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
     e52:	8d 7d e3             	lea    -0x1d(%ebp),%edi
     e55:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
     e58:	83 ec 04             	sub    $0x4,%esp
          s++;
     e5b:	83 c6 01             	add    $0x1,%esi
     e5e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
     e61:	6a 01                	push   $0x1
     e63:	57                   	push   %edi
     e64:	53                   	push   %ebx
     e65:	e8 78 fd ff ff       	call   be2 <write>
        while(*s != 0){
     e6a:	0f b6 06             	movzbl (%esi),%eax
     e6d:	83 c4 10             	add    $0x10,%esp
     e70:	84 c0                	test   %al,%al
     e72:	75 e4                	jne    e58 <printf+0x148>
     e74:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
     e77:	31 ff                	xor    %edi,%edi
     e79:	e9 da fe ff ff       	jmp    d58 <printf+0x48>
     e7e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
     e80:	83 ec 0c             	sub    $0xc,%esp
     e83:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e88:	6a 01                	push   $0x1
     e8a:	e9 73 ff ff ff       	jmp    e02 <printf+0xf2>
     e8f:	90                   	nop
  write(fd, &c, 1);
     e90:	83 ec 04             	sub    $0x4,%esp
     e93:	88 5d e5             	mov    %bl,-0x1b(%ebp)
     e96:	8d 45 e5             	lea    -0x1b(%ebp),%eax
     e99:	6a 01                	push   $0x1
     e9b:	e9 21 ff ff ff       	jmp    dc1 <printf+0xb1>
        putc(fd, *ap);
     ea0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
     ea3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
     ea6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
     ea8:	6a 01                	push   $0x1
        ap++;
     eaa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
     ead:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
     eb0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     eb3:	50                   	push   %eax
     eb4:	ff 75 08             	pushl  0x8(%ebp)
     eb7:	e8 26 fd ff ff       	call   be2 <write>
        ap++;
     ebc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
     ebf:	83 c4 10             	add    $0x10,%esp
      state = 0;
     ec2:	31 ff                	xor    %edi,%edi
     ec4:	e9 8f fe ff ff       	jmp    d58 <printf+0x48>
          s = "(null)";
     ec9:	bb 0d 11 00 00       	mov    $0x110d,%ebx
        while(*s != 0){
     ece:	b8 28 00 00 00       	mov    $0x28,%eax
     ed3:	e9 72 ff ff ff       	jmp    e4a <printf+0x13a>
     ed8:	66 90                	xchg   %ax,%ax
     eda:	66 90                	xchg   %ax,%ax
     edc:	66 90                	xchg   %ax,%ax
     ede:	66 90                	xchg   %ax,%ax

00000ee0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ee0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ee1:	a1 04 17 00 00       	mov    0x1704,%eax
{
     ee6:	89 e5                	mov    %esp,%ebp
     ee8:	57                   	push   %edi
     ee9:	56                   	push   %esi
     eea:	53                   	push   %ebx
     eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     eee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
     ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ef8:	39 c8                	cmp    %ecx,%eax
     efa:	8b 10                	mov    (%eax),%edx
     efc:	73 32                	jae    f30 <free+0x50>
     efe:	39 d1                	cmp    %edx,%ecx
     f00:	72 04                	jb     f06 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f02:	39 d0                	cmp    %edx,%eax
     f04:	72 32                	jb     f38 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
     f06:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f09:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f0c:	39 fa                	cmp    %edi,%edx
     f0e:	74 30                	je     f40 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f10:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f13:	8b 50 04             	mov    0x4(%eax),%edx
     f16:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f19:	39 f1                	cmp    %esi,%ecx
     f1b:	74 3a                	je     f57 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f1d:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f1f:	a3 04 17 00 00       	mov    %eax,0x1704
}
     f24:	5b                   	pop    %ebx
     f25:	5e                   	pop    %esi
     f26:	5f                   	pop    %edi
     f27:	5d                   	pop    %ebp
     f28:	c3                   	ret    
     f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f30:	39 d0                	cmp    %edx,%eax
     f32:	72 04                	jb     f38 <free+0x58>
     f34:	39 d1                	cmp    %edx,%ecx
     f36:	72 ce                	jb     f06 <free+0x26>
{
     f38:	89 d0                	mov    %edx,%eax
     f3a:	eb bc                	jmp    ef8 <free+0x18>
     f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
     f40:	03 72 04             	add    0x4(%edx),%esi
     f43:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f46:	8b 10                	mov    (%eax),%edx
     f48:	8b 12                	mov    (%edx),%edx
     f4a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f4d:	8b 50 04             	mov    0x4(%eax),%edx
     f50:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f53:	39 f1                	cmp    %esi,%ecx
     f55:	75 c6                	jne    f1d <free+0x3d>
    p->s.size += bp->s.size;
     f57:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
     f5a:	a3 04 17 00 00       	mov    %eax,0x1704
    p->s.size += bp->s.size;
     f5f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f62:	8b 53 f8             	mov    -0x8(%ebx),%edx
     f65:	89 10                	mov    %edx,(%eax)
}
     f67:	5b                   	pop    %ebx
     f68:	5e                   	pop    %esi
     f69:	5f                   	pop    %edi
     f6a:	5d                   	pop    %ebp
     f6b:	c3                   	ret    
     f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	57                   	push   %edi
     f74:	56                   	push   %esi
     f75:	53                   	push   %ebx
     f76:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f79:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     f7c:	8b 15 04 17 00 00    	mov    0x1704,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f82:	8d 78 07             	lea    0x7(%eax),%edi
     f85:	c1 ef 03             	shr    $0x3,%edi
     f88:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
     f8b:	85 d2                	test   %edx,%edx
     f8d:	0f 84 9d 00 00 00    	je     1030 <malloc+0xc0>
     f93:	8b 02                	mov    (%edx),%eax
     f95:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
     f98:	39 cf                	cmp    %ecx,%edi
     f9a:	76 6c                	jbe    1008 <malloc+0x98>
     f9c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
     fa2:	bb 00 10 00 00       	mov    $0x1000,%ebx
     fa7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
     faa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
     fb1:	eb 0e                	jmp    fc1 <malloc+0x51>
     fb3:	90                   	nop
     fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fb8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     fba:	8b 48 04             	mov    0x4(%eax),%ecx
     fbd:	39 f9                	cmp    %edi,%ecx
     fbf:	73 47                	jae    1008 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fc1:	39 05 04 17 00 00    	cmp    %eax,0x1704
     fc7:	89 c2                	mov    %eax,%edx
     fc9:	75 ed                	jne    fb8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
     fcb:	83 ec 0c             	sub    $0xc,%esp
     fce:	56                   	push   %esi
     fcf:	e8 76 fc ff ff       	call   c4a <sbrk>
  if(p == (char*)-1)
     fd4:	83 c4 10             	add    $0x10,%esp
     fd7:	83 f8 ff             	cmp    $0xffffffff,%eax
     fda:	74 1c                	je     ff8 <malloc+0x88>
  hp->s.size = nu;
     fdc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     fdf:	83 ec 0c             	sub    $0xc,%esp
     fe2:	83 c0 08             	add    $0x8,%eax
     fe5:	50                   	push   %eax
     fe6:	e8 f5 fe ff ff       	call   ee0 <free>
  return freep;
     feb:	8b 15 04 17 00 00    	mov    0x1704,%edx
      if((p = morecore(nunits)) == 0)
     ff1:	83 c4 10             	add    $0x10,%esp
     ff4:	85 d2                	test   %edx,%edx
     ff6:	75 c0                	jne    fb8 <malloc+0x48>
        return 0;
  }
}
     ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     ffb:	31 c0                	xor    %eax,%eax
}
     ffd:	5b                   	pop    %ebx
     ffe:	5e                   	pop    %esi
     fff:	5f                   	pop    %edi
    1000:	5d                   	pop    %ebp
    1001:	c3                   	ret    
    1002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1008:	39 cf                	cmp    %ecx,%edi
    100a:	74 54                	je     1060 <malloc+0xf0>
        p->s.size -= nunits;
    100c:	29 f9                	sub    %edi,%ecx
    100e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1011:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1014:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1017:	89 15 04 17 00 00    	mov    %edx,0x1704
}
    101d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1020:	83 c0 08             	add    $0x8,%eax
}
    1023:	5b                   	pop    %ebx
    1024:	5e                   	pop    %esi
    1025:	5f                   	pop    %edi
    1026:	5d                   	pop    %ebp
    1027:	c3                   	ret    
    1028:	90                   	nop
    1029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1030:	c7 05 04 17 00 00 08 	movl   $0x1708,0x1704
    1037:	17 00 00 
    103a:	c7 05 08 17 00 00 08 	movl   $0x1708,0x1708
    1041:	17 00 00 
    base.s.size = 0;
    1044:	b8 08 17 00 00       	mov    $0x1708,%eax
    1049:	c7 05 0c 17 00 00 00 	movl   $0x0,0x170c
    1050:	00 00 00 
    1053:	e9 44 ff ff ff       	jmp    f9c <malloc+0x2c>
    1058:	90                   	nop
    1059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1060:	8b 08                	mov    (%eax),%ecx
    1062:	89 0a                	mov    %ecx,(%edx)
    1064:	eb b1                	jmp    1017 <malloc+0xa7>
