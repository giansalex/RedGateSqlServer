SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_NumeroALetras]
 @monto numeric(14,2), --as
 @moneda char(10),-- as
 @letras char(255) output as
begin
declare @unidades char(255),
 @decenas char(255),
 @centenas char(255),
 @especiales char(108),
 @decimales char(25),
 @valor_entero char(9),
 @longitud int,
 @caracteres char(3), 
 @contador int,
 @posicion int,
 @flag  int,
 @decimal int
set nocount on
select @unidades = "un    dos   tres  cuatro" +
    "cinco seis  siete ocho  " +
    "nueve "
select @especiales = "once        doce        trece       "  +
    "catorce     quince      diez y seis "  +
    "diez y sietediez y ocho diez y nueve"
select @decenas = "diez     veinte   treinta  cuarenta " +
    "cincuentasesenta  setenta  ochenta  " +
    "noventa  "
select @centenas = "ciento       doscientos   trescientos  cuatrocientos" +
    "quinientos   seiscientos  setecientos  ochocientos  " +
    "novecientos  "
select @decimal = (@monto - cast(@monto as int)) * 100
select @monto  = round(@monto,0,1)
select @longitud  = LEN( rtrim(cast(cast(@monto as int) as char)))
select @valor_entero = rtrim(cast(cast(@monto as int) as char))
select @valor_entero = replicate("0",9-@longitud)+ substring(@valor_entero,1,@longitud)
select @contador = 1,
 @letras  = replicate(' ',255)
while @contador < 8
 begin /* 0 */
 select @caracteres = substring(@valor_entero,@contador,3)
 if @caracteres <> '000'
  begin /* 1 */
  if substring(@caracteres,1,1) <> '0'
   -- CENTENAS
   begin /* 2 */
   select @posicion = cast(substring(@caracteres,1,1) as int)
   if  @posicion = '1' and
    cast(substring(@caracteres,2,2) as int) = 0
    begin /* 3 */
    
    select @letras = rtrim(@letras) +
       " Cien "
    end /* 3 */
   else
    begin /* 4 */
    select @letras = rtrim(@letras)      +
       " "       +
       substring(@centenas, 13 * (@posicion - 1) + 1,13)
    end /* 4 */
   end /* 2 */
  select @flag = 0
  if cast(substring(@caracteres,2,2) as int) > 10 and
   cast(substring(@caracteres,2,2) as int) < 20
   -- ESPECIALES
   begin /* 5 */
   select @posicion = cast(substring(@caracteres,3,1) as int)
   select @letras = rtrim(@letras)      +
      " "       +
      substring(@especiales, 12 * (@posicion - 1) + 1,12)
   select @flag = 1
   end /* 5 */
  if @flag = 0
   -- DECENAS
   begin /* 6 */
   if substring(@caracteres,2,1) <> '0'
    begin /* 7 */
    select @posicion = cast(substring(@caracteres,2,1) as int)
    if @posicion <> 2 or
     substring(@caracteres,3,1) = '0'
     begin /* 8 */
     select @letras = rtrim(@letras)      +
        " "       +
        substring(@decenas, 9 * (@posicion - 1) + 1,9)
     
     end /* 8 */
    else
     begin /* 9 */
     
     select @letras = rtrim(@letras)      +
        " veinti"
     end /* 9 */
    
    end /* 7 */
   
   if substring(@caracteres,3,1) <> '0'
 
    -- UNIDADES
    begin /* 10 */
    select @posicion = cast(substring(@caracteres,3,1) as int)
    if substring(@caracteres,2,1) <> '0' and
     substring(@caracteres,3,1) <> '0'
     begin /* 11 */
     if substring(@caracteres,2,1) = '2'
      select @letras = rtrim(@letras)     +
         substring(@unidades, 6 * (@posicion - 1) + 1,6)
     else
      select @letras = rtrim(@letras)     +
         " y "      +
         substring(@unidades, 6 * (@posicion - 1) + 1,6)
     end /* 11 */
    
    else
     select @letras = rtrim(@letras)      +
        " "       +
        substring(@unidades, 6 * (@posicion - 1) + 1,6)
    end /* 10 */
 
   end /* 6 */
  if @contador = 1
   begin /* 12 */ 
   if @posicion   = 1 and
    substring(@caracteres,1,2) = '00'
    begin /* 13 */
    select @letras = rtrim(@letras) +
       " millón "
    end /* 13 */
   else
 
--    if @posicion = 1
     begin /* 14 */
 
     select @letras = rtrim(@letras) +
        " millones "
     end /* 14 */
   end /* 12 */
  else
   begin /* 15 */
   if @contador = 4
    begin /* 16 */
    select @letras = rtrim(@letras) +
       " mil "
    end /* 16 */
   end /* 15 */
  end /* 1 */
 select @contador = @contador + 3
  
 end /* 0 */
-- CIENTOS
if right(rtrim(@letras),6) = 'ciento'
 begin /* 17 */
 select @letras = substring(@letras,1,len(rtrim(@letras))-6) +
    "cien "
 end /* 17 */
-- DECIMALES
if @decimal > 0
 select @decimales = "  " + @moneda + " con "        +
     replicate ('0' ,2 - len(rtrim(ltrim(cast (@decimal as char(2)))))) +
     ltrim(rtrim(cast (@decimal as char(2))))   +
     "/100"
else
 select @decimales = "  " + @moneda + " exactos"
-- FINAL
select @letras  = '** '    +
    rtrim(substring(@letras,1,255)) +
    rtrim(@decimales)  +
    ' **'
select "letras" = UPPER(@letras)
end

GO
