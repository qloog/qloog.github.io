---
layout: post
title: epoll与select/poll性能，CPU/内存开销对比
date: 2014-05-28 19:23
category: 收藏
tags: epoll select
---


Epoll 是 Linux 内核在2.5.44版本引进的一个新特性，旨在替换之前系统中老的 select, poll 等系统请求。这是 Linux I/O 系统一次质的飞跃。关于 Epoll 的详细的介绍见 [Wikipedia](http://en.wikipedia.org/wiki/Epoll)。

Epoll 在绝大多数情况下性能都远超 select 或者 poll，但是除了速度之外，三者之间的 CPU 开销，内存消耗情况又怎么样呢？

本文的内容来自 Stackoverflow 上一次精彩的问答，除了比较 poll， select 和 epoll 在性能，系统资源消耗等方面的差异之外，还指出了epoll 在对普通文件支持方面相对于 select/poll 的不足之处（当然，这三者本身都不支持普通文件，只是作者认为 epoll 对这类问题的处理机制不好，这是个见仁见智的事情，不代表作者的观点是正确的）。希望对这个Topic感兴趣的同学能够看完这篇文章，相信能使你对epoll有个更深的了解。

问：

> Everything I’ve read and experienced ( Tornado based apps ) leads me to believe that ePoll is a natural replacement for Select and Poll based networking, especially with Twisted. Which makes me paranoid, its pretty rare for a better technique or methodology not to come with a price.

> Reading a couple dozen comparisons between epoll and alternatives shows that epoll is clearly the champion for speed and scalability, specifically that it scales in a linear fashion which is fantastic. That said, what about processor and memory utilization, is epoll still the champ?

答：

> For very small numbers of sockets (varies depending on your hardware, of course, but we’re talking about something on the order of 10 or fewer), select can beat epoll in memory usage and runtime speed. Of course, for such small numbers of sockets, both mechanisms are so fast that you don’t really care about this difference in the vast majority of cases.

> One clarification, though. Both select and epoll scale linearly. A big difference, though, is that the userspace-facing APIs have complexities that are based on different things. The cost of a select call goes roughly with the value of the highest numbered file descriptor you pass it. If you select on a single fd, 100, then that’s roughly twice as expensive as selecting on a single fd, 50. Adding more fds below the highest isn’t quite free, so it’s a little more complicated than this in practice, but this is a good first approximation for most implementations.

> The cost of epoll is closer to the number of file descriptors that actually have events on them. If you’re monitoring 200 file descriptors, but only 100 of them have events on them, then you’re (very roughly) only paying for those 100 active file descriptors. This is where epoll tends to offer one of its major advantages over select. If you have a thousand clients that are mostly idle, then when you use select you’re still paying for all one thousand of them. However, with epoll, it’s like you’ve only got a few – you’re only paying for the ones that are active at any given time.

> All this means that epoll will lead to less CPU usage for most workloads. As far as memory usage goes, it’s a bit of a toss up. select does manage to represent all the necessary information in a highly compact way (one bit per file descriptor). And the FD_SETSIZE (typically 1024) limitation on how many file descriptors you can use with select means that you’ll never spend more than 128 bytes for each of the three fd sets you can use with select (read, write, exception). Compared to those 384 bytes max, epoll is sort of a pig. Each file descriptor is represented by a multi-byte structure. However, in absolute terms, it’s still not going to use much memory. You can represent a huge number of file descriptors in a few dozen kilobytes (roughly 20k per 1000 file descriptors, I think). And you can also throw in the fact that you have to spend all 384 of those bytes with select if you only want to monitor one file descriptor but its value happens to be 1024, wheras with epoll you’d only spend 20 bytes. Still, all these numbers are pretty small, so it doesn’t make much difference.

> And there’s also that other benefit of epoll, which perhaps you’re already aware of, that it is not limited to FD_SETSIZE file descriptors. You can use it to monitor as many file descriptors as you have. And if you only have one file descriptor, but its value is greater than FD_SETSIZE, epoll works with that too, but select does not.

> Randomly, I’ve also recently discovered one slight drawback to epoll as compared to select or poll. While none of these three APIs supports normal files (ie, files on a file system), select and poll present this lack of support as reporting such descriptors as always readable and always writeable. This makes them unsuitable for any meaningful kind of non-blocking filesystem I/O, a program which uses select or poll and happens to encounter a file descriptor from the filesystem will at least continue to operate (or if it fails, it won’t be because of select or poll), albeit it perhaps not with the best performance.

> On the other hand, epoll will fail fast with an error (EPERM, apparently) when asked to monitor such a file descriptor. Strictly speaking, this is hardly incorrect. It’s merely signalling its lack of support in an explicit way. Normally I would applaud explicit failure conditions, but this one is undocumented (as far as I can tell) and results in a completely broken application, rather than one which merely operates with potentially degraded performance.

> In practice, the only place I’ve seen this come up is when interacting with stdio. A user might redirect stdin or stdout from/to a normal file. Whereas previously stdin and stdout would have been a pipe — supported by epoll just fine — it then becomes a normal file and epoll fails loudly, breaking the application.