import os
import random
import asyncio
from time import sleep
from sys import argv
import requests
import bs4
from bs4 import BeautifulSoup

c = requests.Session()
c.keep_alive = False
def GET_UA():
    uastrings = ["Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36",\
                "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.72 Safari/537.36",\
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10) AppleWebKit/600.1.25 (KHTML, like Gecko) Version/8.0 Safari/600.1.25",\
                "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0",\
                "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36",\
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36",\
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/600.1.17 (KHTML, like Gecko) Version/7.1 Safari/537.85.10",\
                "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",\
                "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0",\
                "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.104 Safari/537.36",\
                "Mozilla/5.0 (Linux; Android 5.1; A1603 Build/LMY47I; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/43.0.2357.121 Mobile Safari/537.36"\
                ]
 
    return random.choice(uastrings)
ua={"User-Agent": GET_UA()}

loop = asyncio.get_event_loop()

async def opening_link(username,num,rnum):
    url = username
    #numtor = 9050 + int(num)
    #proxies = { 'http': "socks5h://localhost:{}".format(numtor),
    #'https': "socks5h://localhost:{}".format(numtor)
    #}
	#, proxies=proxies, verify=False
    r = c.get(url, headers=ua, timeout=15, allow_redirects=True)
    soup = BeautifulSoup(r.content,"html.parser")
    if "Access denied" in str(soup):
        os.system(str("redis-cli set " + str(rnum) + "denied true"))
    for dat in soup.find_all('div',class_="container-fluid"):
        code = dat.get('data-code')
        timer = dat.get('data-timer')
        tokena = dat.get('data-token')
        print("waiting for " + timer + " seconds...")
        sleep(int(timer))
        r = c.post("https://dogeclick.com/reward",data={"code":code,"token":tokena}, headers=ua, timeout=15)
        print("site, visited!!!")
        exit(0)

async def main():
    if len(argv) == 4:
            await opening_link(argv[1],argv[2],argv[3])

loop.run_until_complete(main())
