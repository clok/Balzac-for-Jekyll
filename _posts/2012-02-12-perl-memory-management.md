---
layout: post
title: Memory “Management” in Perl
description: ""
category: articles
tags: [ memory management, optimization, perl]
image:
  feature: mem_test_dual_noforce_oom_mem_plot.png
---

<figure>
  <img src="/images/mem_test_dual_noforce_oom_mem_plot.png">
  <figcaption>This is bad.</figcaption>
</figure>

In my early days with Perl I have found myself viewing the memory management of a Perl app much like the Wizard of Oz. Magically it just works, but I knew there was something logical happening behind the curtain.  Some peculiar behavior in my early scripts, namely memory growth explosions, had me looking behind the curtain to better understand how Perl works and how to build my objects more efficiently.

For nearly all small scale scripts there is no need to worry about how memory works in Perl. Perl uses reference counting for its garbage collection and it functions very well.  Some considerations should be taken when using different lexical types (hash, array, etc). Perl will hold onto the memory that is allocated for these types, even if undef‘d and when they fall out of scope, in case these named types are used again. You can’t always trust Perl to figure out what you want to have happen, so I have found it useful to move reused my‘d variables to the outer most logical scope to try and take advantage of this feature. Perl holds onto this memory in an attempt to increase performance since Perl is not releasing the memory to the OS and reserving it for internal use. This memory will be released by Perl while running if absolutely needed by the OS, otherwise the garbage collection will not release the memory until death. Below is a very simple example of this in action:

~~~ ruby
my @first;
$first[24999999] = 1;
my $i = 0;
for (1...25000000) {
   $first[$i] = 1;
   $i++;
}
 
undef @first;
sleep(5);
my @second;

$second[24999999] = 1;
$i = 0;
for (1...25000000) {
   $second[$i] = 1;
   $i++;
}
~~~

<figure>
  <img src="/images/mem_test_dual_presized_mem_plot.png">
  <figcaption>Perl memory usage plot for the code snippet above.</figcaption>
</figure>

If we take the above code and modify the second construction of the array to be twice the size, we find that after the sleep there is an initial presize allocation then reuse of the previously allocated memory. Once the array begins allocating beyond the @first size, we see growth in the memory footprint.

<figure>
  <img src="/images/mem_test_dual_presized_double_mem_plot.png">
  <figcaption>Perl will reuse previously allocated memory for lexical types if the memory has been freed internally.</figcaption>
</figure>

Going back to having the arrays set to the same initial size, if we do not undef the @first array we see that the @second array does not use the previously allocated memory as we saw above.

<figure>
  <img src="/images/mem_test_dual_uniq_no_undef_plot.png">
  <figcaption>Without the undef of @first we see that the @second does grow within new memory as expected.</figcaption>
</figure>

The behavior for hashes is a little harder to demonstrate, but the same principles still hold true. It’s important to note that Perl hashes are much heavier than arrays due to the fact that the key is a structure in itself. Their growth patterns are much less linear than the arrays that I presented in this post, but they are still predictable. I will go into hash usage in more detail in upcoming post.

These may be simple examples, but I believe they make it clear that if you are planning to process large data sets there are concerns that must be considered when using Perl. Below are some helpful links if you want to dive deeper yourself.

Recommended reading:

* [PerlGuts Illustrated: illguts(1)](http://cpansearch.perl.org/src/RURBAN/illguts-0.49/index.html)
* [Perl Monks: Memory Management Links](http://www.perlmonks.org/?node_id=336883)
* [Devel::Size](http://search.cpan.org/~nwclark/Devel-Size-0.77/lib/Devel/Size.pm) – many caveats, but still useful.