# Swift app using NewsAPI

### Aplikacija se sastoji od 3 ekrana

**1. ekran(Headlines tab)**:
   - Povlaci podatke s top-headlines api-ja
   - Na vrhu ekrana postoje dva gumba "sort" i meni, klikom na "sort" izmjenjuje se poredak clanaka prikazanih po datumu (silazno/uzlazno).
   - Klikom na meni bira se jedna od podgrupa clanaka koje sam ja stavio jer sam ih smatrao najcescima i najkorisnijima, klikom na neku od kategorija mijenja se api zahtjev
   i dohvacaju se novi clanci.
   - Svaki clanak na sebi ima 2 gumba. Jedan za spremanje clanka (klikom na njega clanak ide u 3. ekran) i drugi je za "share" clanka.
   - Klikom na sam clanak otvara se taj cijeli clanak na svojoj web adresi.
   - Clanci se mogu pretrazivati po kljucnim rijecima

**2. ekran(Search tab)**:
   - Ovo je ekran koji dohvaca podatke s "everything" endpointa, ali sam ga napravio ovako jer sam mislio da je prakticnije
   - Ne prikazuje se nista dok se ne upise nesto u search bar, taj tekst sto je u search baru ulazi u "query" filter api linka i klikom na enter dohvaca podatke s tim
     queryjem koji je upisan. Postoji recent searches dio u koji stane nekoliko zadnjih pretrazivanja i trajno su spremljeni (i nakon zatvaranja aplikacije)
   - Takoder svaki clanak ima gumbe "bookmark" i "share"

**3. ekran(Bookmarks)**:
   - Tu se prikazuju svi clanci koje smo spremili, trajno ostaju tamo sve dok ih ne uklonimo ponovnim klikom na "bookmark" gumb
   - Clanci se mogu pretrazivati po kljucnim rijecima
