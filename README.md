# 8086-interrupt

Bu proje kapsamında, 8086 mikroişlemcisi ile 8251A USART ve 8259 Programlanabilir Kesme Denetleyicisi (PKD) kullanılarak seri veri alışverişi gerçekleştiren ve kesme mantığı ile çalışan bir sistem Proteus ortamında tasarlanmıştır. Aşağıda yapılan işlemler sırasıyla açıklanmıştır:

## Donanım Yapılandırması ve Bağlantılar

8086 mikroişlemcisi temel işlemci olarak devreye yerleştirildi.

8259 PKD, kenar tetiklemeli kesme desteği sağlamak üzere uygun şekilde yapılandırıldı.

8251A USART, sanal terminal ile veri alışverişi yapacak şekilde TXD ve RXD bacakları aracılığıyla bağlandı.

USART ayarları, sanal terminal ile uyumlu şekilde 9600 baud, 8-bit veri, paritesiz olarak yapılandırıldı.

## Kesme Vektör Tablolarının Ayarlanması

Seri veri alma kesmesi INT 50H numaralı vektör tablosu gözüne yerleştirildi. (0000:0140)

Seri veri gönderme kesmesi INT 51H numaralı göze yerleştirildi. (0000:0144)

## Yazılım Geliştirme

USART ile gelen veriyi okuyan kesme alt programı yazıldı. Bu program, RXD’den gelen karakteri alıp SHR AL,1 komutu ile simülasyon hatasını önleyerek işledi.

Alınan karakterin ASCII değeri bir artırılarak bir diziye aktarıldı.

Dizi 5 karaktere ulaştığında INT 51H kesmesi tetiklenerek tüm karakterler TXD üzerinden sanal terminale geri gönderildi.

## Test ve Doğrulama

Terminalden sırayla '1', '2', '3', '4', '5' karakterleri gönderildi.

Sistem bu karakterleri alıp ASCII değerlerini birer artırarak '2', '3', '4', '5', '6' olarak geri gönderdi.

İşlem kesme mekanizmasıyla ve belirlenen vektörlere bağlı kalınarak başarıyla gerçekleştirildi.

## Proteus Simülasyonu

Devre, Proteus ortamında başarıyla çalıştırıldı.

Kesme çağrıları, USART veri alışverişi ve karakter dizisinin işlenmesi doğru şekilde gözlemlendi.

Bu işlemler sonucunda, seri veri kesme mekanizmasının doğru çalıştığı ve istenen koşulları sağladığı doğrulanmıştır. Kodlama, bağlantı ve test adımları belirtilen kurallara uygun olarak tamamlanmıştır.

