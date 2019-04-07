We have 3 class to extract the statistics of any text which are Letters, Words,
Successors. Text generator part has only one class which called Text_Generator.
Text_Generator uses other 3 class to obtain statistics and after that it
generates a text by using a starting word and its successors.

We handle with capital letters by converting every word to lower case.

We used dictionary and nested dictionary structures. dictionary is for storing
count of letters and words; nested dictionary is for storing successors of word.

#### Call from terminal (outfile is optional):

```
./text_stats.py <filename> <outfile>
#  ./text_stats.py shakespeare.txt out.txt
./generate_text.py <filename> <start_word> <max_word_count> <outfile>
#  ./generate_text.py shakespeare.txt my 100 out.txt
```

#### Use as package:

--- for text_stats
```
from text_stats import *
# now we can get stats with this line:
# letters, words, successors = return_stats(in_fname)
# and we can access letters, words, successors class function to work.
```
--- for generate_text
```
from generate_text import *
# Now we can just create an object of Text_Generator with this line
# text_gen = Text_Generator(in_fname)
# and generate text with:
# text_gen.generate_text(start_word, max_word_count)
# text_gen.print_stdout()
```
