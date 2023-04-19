## RecipeBook

### Aplicacion para el listado de recetas

Esta aplicacion se creo en con una arquitectura VIP, 
utilizo el pod SDWebImage para la descarga de imagenes, 
se siguen los patrones de sofware delegates para la dectcion de la interacion del usuario y hacer la navegacion,
como para la comunicacion entre las diferentes capas de la arquitectura view -> interactor -> presenter -> view,
dependency injection para la capa de red para poder hacer un switch el el modo de hacer las peticiones, 
realizo pruebas unitarias para el testeo de los servicios
