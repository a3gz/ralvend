Welcome to **RalVend** the open source vendor system for Second Life. 

I started this project because I needed a simple vendor to sell my products in-world and offer redeliveries. Any vendor in existence offers these features but having too few sales, I wasn't willing to pay handreds or thousands of L$ for every single gadget.

CasperVend has a free vendor that collects 5% of sales, which is reasonable considering that the marketplace charges 10%. My problem with CasperVend though was the overhead. If I had a large store with several thousands of L$ in sales per week, I would use CasperVend.

RalVend is for the little store owners like myself who have more skills than cash flow.

But there's another reason why I decided to start this project and that's the same reason why we love open source software so much: **freedom**!. I know that there are a lot of people who think this way, and that is why I decided to make RalVend a public open-source project on GitHub under the MIT license.

## Contribute

I don't even want to spend too much time thinking about anything other than building this thing and make it work. For now, the only thing I can say to those who are thinking about contributing to the project is: **(1)** thank you very much and **(2)** please, look at the code and make sure to respect the coding style.
I've seen LSL code writteing in many different styles; I have mine of course and once this gets going, for consistency's sake, contributed code must use the same style.

## Environment

I use Firestorm for development. Releases will have ready-to-use code under the `release` directory, that's what you should look for if you only want to setup RalVend in your store.
If you are interested in contributing, you will have to setup your Firestorm environment and place the project in a directory so the following line points to the intended file:

  #include "ralvend/lib/dialog.lsl"

Basically, this means that the project must be located diretly inside whatever directory you told Firestorm to look for code in your computer. Also, your development copy of the project must be called `ralvend`.
If you change anything of this, Firestorm won't be able to find the dependencies and your code won't compile.