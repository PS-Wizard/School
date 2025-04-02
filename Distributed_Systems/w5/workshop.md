# About to create a virtual machine
![abouttocreatevirtualmachine](assets/abouttocreatevirtualmachine.png)

We've just navigated to the page to create a new virtual machine.

>

# Configuring a new virtual machine
![instancedetails](assets/instancedetails.png)
Here, we selected a name, a region, a security type, for our virtual machine.

![rdp](assets/rdp.png)
Furthermore, we chose Windows Datacenter as our image with an x64 architecture, and we configured it with 1 virtual cpu and 2 Gibibytes ~ translating to 2.15 Gigabytes of memory. Along with the standard inbound ports--HTTP(80), HTTPS(443) and SSH(22)-- we also manually opened port 3389 for RDP access.

>
![part1](assets/part1.png)
![part2](assets/part2.png)

The above 2 images show the overall configuration of our new virtual machine. After rechecking our configuration we went on to review and create the virtual machine.
>

![validationpassed](assets/validationpassed.png)

This is azure prompting us that the validation for our new virtual machine has passed, and now we may move on to deploy the virtual machine.
>

![deploymentinprocess](assets/deploymentinprocess.png)

This is us in the process of deploying our virtual machine.
>

![deploymentdone](assets/deploymentdone.png)

This is azure prompting us that our deployment has been done successfully.
>

![description](assets/description.png)
![description2](assets/description2.png)

The above 2 images show the description of our now deployed virtual machine, where we took note of our Public IP address to be used later in the Remote Desktop Protocol Software. In my case the Public IP happened to be `52.255.206.99`
>

![screenshot](assets/screenshot.png)

Here, we logged in to the virutal machine using our RDP software and now are selecting the installation type for our virtual machine. We chose Role-based installation because we are configuring a single server where only I will log in; unlike RDS installation which assumes a setup for multiple users to access a virtual desktop or apps.
>

![basicAuth](assets/basicAuth.png)
Here, we selected Basic Authentication and Windows Authentication along with IIS management console .
- **Basic Authentication** : This is a simple username/password combo sent with each request (encoded in Base64, but not encrypted unless used with HTTPS)
- **Windows Authentication** : Uses the **Logged in windows account's credentails** for the basic authentication
- **IIS Management Console** : It is a graphical tool to configure sites, bindings (http, https etc) and authentication (basic, windows etc), SSL certificates etc. Its basically the main way to manage IIS without using the console.
>


![something1](assets/something1.png)
![something2](assets/something2.png)

The above 2 images show the list of features & role-services we picked to install on our virtual machine.
>

![installationsuccess](assets/installationsuccess.png)

This is the installation wizard prompting us that our installation succeeded and we may proceed further.
>

![iss](assets/iss.png)
![idk](assets/something.png)
![somethingelse](assets/somethingelse.png)

The above 3 images show, us opening up the IIS manager that we installed, to find the default location where our webpage was stored on by going inside; in my case, `swoyam2431342` > `sites` > `Default Website` > `Basic Settings` and copied the Physical path for the default `.htm` document which happened to be on `C:\inetpub\wwwroot`. After which we navigated to the path `C:\inetpub\wwwroot` using the file explorer.
>

![index.html](assets/index.html)
After navigating to the path, we created a new `index.html` with the content:
```html

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tiny-slider/2.9.4/tiny-slider.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tiny-slider/2.9.4/min/tiny-slider.js"></script>
    <style>
        *{
  margin: 0;
}
header{
  background-color: #262626;
}

li{
  list-style: none;
}

a{
  color: white;
  text-decoration: none;
}

.container{
  max-width: 1224px;
  width: 92%;
  margin: 0 auto;
}

.navbar{
  min-height: 70px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-branding{
  font-size: 2rem;
}

.nav-menu{
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 60px;
}

.nav-link{
  transition: 0.3s ease-out;
}

.nav-link:hover{
  color: dodgerblue;
}

.hamburger{
  display: none;
  cursor: pointer;
}

.bar{
  display: block;
  width: 25px;
  height: 3px;
  margin: 5px auto;
  -webkit-transition: all 0.3s ease;
  transition: all 0.3s ease;
  background-color: white;
}

@media(max-width:1024px){
  .hamburger{
    display: block;
  }

  .hamburger.active .bar:nth-child(2){
    opacity: 0;
  }
  .hamburger.active .bar:nth-child(1){
    transform: translateY(8px) rotate(45deg);
  }
  .hamburger.active .bar:nth-child(3){
    transform: translateY(-8px) rotate(-45deg);
  }

  .nav-menu{
    position: fixed;
    left: -100%;
    top: 70px;
    gap: 0;
    flex-direction: column;
    background-color: #262626;
    width: 100%;
    text-align: center;
    transition: 0.3s;
  }

  .nav-item{
    margin: 16px 0;
  }

  .nav-menu.active{
    left: 0;
  }
}

#testimonials-section {
  height: auto;
  background-color: black;
  margin-top: 80px; 
}


.container{
  width: 1600px;
  margin: auto;
}

.subcontainer{
  width: 85%;
  margin: auto;
}

.testimonials-wrapper {
  width: 100%;
  height: auto;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 25px;
  padding-top: 10px;
  position: relative;
}

.slide-img {
  height: 110px;
  width: 110px;
  margin: auto;
  border-radius: 50%;
  border: 5px solid lightgray;
  background-position: center;
  background-size: cover;
  box-shadow: 0 0 5px #bbb;
}

.img-1{
  background-image: url(https://images.pexels.com/photos/2128807/pexels-photo-2128807.jpeg?cs=srgb&dl=pexels-david-garrison-2128807.jpg&fm=jpg);
}

.img-2{
  background-image: url(https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?cs=srgb&dl=pexels-pixabay-415829.jpg&fm=jpg);
}

.img-3{
  background-image: url(https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?cs=srgb&dl=pexels-italo-melo-2379005.jpg&fm=jpg);
}

.header {
  color: white;
  text-align: center;
}

.header h1 {
  font-size: 2.5rem;
}

.slider-wrapper {
  width: 100%;
}

.slide {
  width: 100%;
  text-align: center;
  color: white;
  line-height: 1.5;
  font-style: italic;
  padding: 0 40px;  
}

.slide p{
  padding-bottom:20px;
}

.previous,
.next {
  padding: 2px;
  width: 30px;
  cursor: pointer;
  border-radius: 50%;
  outline: none;
  transition: 0.7s ease-in-out;
  border: 3px solid white;
  background-color: black;
  box-shadow: 0 0 5px #bbb;
  position: absolute;
  top: 50%;
  z-index: 1;
}

.previous {
  left: 0%;
}

.next {
  right: 0%;
}

.previous:hover,
.next:hover {
  border: 3px solid white;
}

#controls i {
  color: white;
  font-size: 1rem;
}

.tns-nav {
  text-align: center;
}

.tns-nav button {
  border: none;
  padding: 8px;
  border-radius: 50%;
  background-color: white;
  margin-left: 15px;
}

.tns-nav .tns-nav-active {
  background-color: gray;
}

@media(max-width:1600px){
  .container{
    width: 100%;
  }
}
    </style>
</head>
<body>
    <header>
        <div class="container"> 
            <nav class="navbar">
              <a href="#" class="nav-branding">Azure</a>
              <ul class="nav-menu">
                <li class="nav-item">
                  <a href="#" class="nav-link">Home</a>
                </li>
                <li class="nav-item">
                  <a href="#" class="nav-link">About</a>
                </li>
                <li class="nav-item">
                  <a href="#" class="nav-link">Contact</a>
                </li>
              </ul>
              <div class="hamburger">
                <span class="bar"></span>
                <span class="bar"></span>
                <span class="bar"></span>
              </div>
            </nav>
         </div>
       </header>
       <section id="testimonials-section">
        <div class="container">
          <div class="subcontainer">
    
            <div class="testimonials-wrapper">
    
              <div class="header">
                <h1>Testimonials</h1>
              </div>  
              
              <div class="slider-wrapper">
                <div class="slider">
                  <div class="slide">
                    <div class="slide-img img-1"></div>
                    <br>
                    <h2>"Lorem ipsum dolor sit amet consectetur adipisicing elit. In eligendi quisquam praesentium totam. Maiores, distinctio
                    eos? Tempora nihil corporis dolorem."</h2> Lorem20
                    <br>
                    <p>- Michael Smith / CEO of Lorem</p>
                  </div>
    
    
                  
                  <div class="slide">
                    <div class="slide-img img-2"></div>
                    <br>
                    <h2>"Lorem ipsum dolor sit amet consectetur adipisicing elit. In eligendi quisquam praesentium totam. Maiores, distinctio eos? Tempora nihil corporis dolorem."</h2>
                    <br>
                    <p>- Cristal Pettis / CEO of Lorem</p>
                  </div>
                  <div class="slide">
                    <div class="slide-img img-3"></div>
                    <br>
                    <h2>"Lorem ipsum dolor sit amet consectetur adipisicing elit. In eligendi quisquam praesentium totam. Maiores, distinctio
                    eos? Tempora nihil corporis dolorem."</h2>
                    <br>
                    <p>- Tyler Evans / CEO of Lorem</p>
                  </div>
                </div>
              </div>
              <div id="controls">
                <button class="previous"><i class="fas fa-angle-left"></i></button>
                <button class="next"><i class="fas fa-angle-right"></i></button>
              </div>
            </div>
          </div>
        </div>
      </section>
      <script>
        const hamburger = document.querySelector(".hamburger");
const navMenu = document.querySelector(".nav-menu");

hamburger.addEventListener("click", () => {
  hamburger.classList.toggle("active");
  navMenu.classList.toggle("active");
})

document.querySelectorAll(".nav-link").forEach(n => n.addEventListener("click", () => {
  hamburger.classList.remove("active");
  navMenu.classList.remove("active");
}))
        const tnslider = tns({
    container: ".slider",
    slideBy: 1,
    speed: 700,
    nav: true,
    navPosition: "bottom",
    autoplay: true,
    autoplayTimeout: 6000,
    autoplayButtonOutput: false,
    controlsContainer: '#controls',
    prevButton: ".previous",
    nextButton: ".next"
  });
    </script>

</body>
</html>
```

>
![hostedWebsie](assets/hostedWebsie.png)

After creating the `index.html` file, we than navigated to `{OUR_VMS_PUBLICIP}/index.html`, in my case that was `52.255.206.99/index.html` to view the webpage that we just created.
>

![basicauth](assets/basicauth.png)
![restartingwebsite](assets/restartingwebsite.png)

The above 2 images, show us enabling basic authentication for our website, and restarting the server. After which trying to access that webpage propmpts us to enter our username & password combination.
>

![selfSignedCertificate](assets/selfSignedCertificate.png)

The above image shows the creation of a self signed certificate to enable the use of `HTTPS` on our webpage. 
>

![restartingwebsite](assets/restartingwebsite.png)

After creating the SSL certificate, we proceeded to restart the website for `https` to take place and the image below shows https working:

![httpsworking](assets/httpsworking.png)
>

![stopped](assets/stopped.png)
Finally, to prevent our credit depleting, we stop our virtual server entirely.

