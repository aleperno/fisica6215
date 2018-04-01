0;

global H = 6.6216 * 10^-34;
global C = 2.998 * 10^8;
global K = 1.3807 * 10^-23;

global t1 = 400 + 273;
global t2 = 800 + 273;
global t3 = 1200 + 273;

function f = radiancia(_long, temp)
  # _long se considera viene en angstroms
  # temp se considera viene en kelvin
  global H;
  global C;
  global K;
  long = _long .* 10^-10; # Paso a metros
  pow = ((H.*C)./(long.*K.*temp));
  f = ((2.*pi.*H.*C.^2)./(long.^5)) .* (1 ./ ((e.^pow) - 1));
 endfunction
 

# Grafico de 0 a 80.000 Angstroms
min = 0;
max = 80000;
step = 10;

x = min:step:max;

plot(x, radiancia(x, t1), "linewidth", 2, "color", "blue", ':');
legend("400 C");
hold on;
plot(x, radiancia(x, t2), "linewidth", 2, "color", "magenta", '--');
legend("800 C");
hold on;
plot(x, radiancia(x, t3), "linewidth", 2, "color", "red");
hold on;
# Encuentro el límite del Eje Y para graficar una línea vertical
_ylim = ylim;
plot([4000, 4000], _ylim, "linewidth", 2, "color", "black", "--");
hold on;
plot([7500, 7500], _ylim, "linewidth", 2, "color", "black", ":");
# Aplico las leyendas
legend("1200 C");
xlabel("λ [Å]");
ylabel("Radiancia [W/m^3]");
legend("400 °C", "800 °C", "1200 °C", "4000 Å", "7500 Å");

#{
  Para marcar los puntos en la cuál la radiancia es máxima, debo hallar los
  máximos de la funcion para cada una de las temperaturas. Para ello defino
  otras funciones donde sólo depende de la longitud de onda y devuelve el signo
  opuesto, para emplear la funcion de hallar mínimos.
#}
func = @(x) radiancia(x, t3) * -1;
[xmin, f_min_val] = fminbnd(func, 0, 80000);
xmax = xmin;
f_max_val = -f_min_val;
plot(xmax, f_max_val, 'r*', 'linewidth', 5, "color", "red");
aux = sprintf("(%i, %.2e)", xmax, f_max_val);
text(xmax, f_max_val+0.3*10^10, aux);  # Se imprime con un offset para que sea legible

func = @(x) radiancia(x, t2) * -1;
[xmin, f_min_val] = fminbnd(func, 0, 80000);
xmax = xmin;
f_max_val = -f_min_val;
plot(xmax, f_max_val, 'r*', 'linewidth', 5, "color", "magenta");
aux = sprintf("(%i, %.2e)", xmax, f_max_val);
text(xmax, f_max_val+0.3*10^10, aux);

func = @(x) radiancia(x, t1) * -1;
[xmin, f_min_val] = fminbnd(func, 0, 80000);
xmax = xmin;
f_max_val = -f_min_val;
plot(xmax, f_max_val, 'r*', 'linewidth', 5, "color", "blue");
aux = sprintf("(%i, %.2e)", xmax, f_max_val);
text(xmax, f_max_val+0.3*10^10, aux);
hold off;

#------------------- Rango Visible ------------------------
# Gráfico para el rango visible
figure(2);
min = 4000;
max = 7500;
step = 10;

x = min:step:max;
plot(x, radiancia(x, t1), "linewidth", 2, "color", "blue", ':');
legend("400 C");
hold on;
plot(x, radiancia(x, t2), "linewidth", 2, "color", "magenta", '--');
legend("800 C");
hold on;
plot(x, radiancia(x, t3), "linewidth", 2, "color", "red");
legend("1200 C");
xlabel("λ [Å]");
ylabel("Radiancia [W/m^3]");
legend("400 °C", "800 °C", "1200 °C");
# Se ajusta el eje y (experimental) para que se observen mejor las tres curvas
axis([0 1 0 5*10^7], "autox");
hold off;

# ------------------------------
#{
Calcular la radiancia espectral a los 1600 nm para cada una de las temperaturas
del punto a)
#}
r1 = radiancia(16000, t1);
r2 = radiancia(16000, t2);
r3 = radiancia(16000, t3);

printf("La radiancia espectrai a los 1600 nm y 400 °C es de %e\n", r1);
printf("La radiancia espectrai a los 1600 nm y 800 °C es de %e\n", r2);
printf("La radiancia espectrai a los 1600 nm y 1200 °C es de %e\n", r3);
# -----------------------------
#{
Calcular la radiancia en el rango visible para cada una de las temperaturas del punto
a). Resolver “exactamente” utilizando algún método numérico y la aproximación del
rectángulo. Comparar ambos resultados.
#}
function f = square_aprox(temp, n)
  min = 4000;
  max = 7500;
  square_width = (max - min) / n;
  #printf("El ancho del cuadrado es %f\n", square_width);
  sum = 0;
  for i = 1:n
    point = min + ((i-0.5) * square_width);
    #printf("Uso el punto %f\n", point);
    sum += square_width * radiancia(point, temp);
   end;
   # Compenso con angstrom
   f = sum * 10^-10;
endfunction

for i = [t1 t2 t3]
  for j = [1 10000]
    val = square_aprox(i, j);
    printf("Aproximando la radiancia a %d °C con %d rectángulos da %e\n", i, j, val);
  end;
end;


