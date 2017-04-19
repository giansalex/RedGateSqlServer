SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****
-- OJO: AL PARECER ESTE SP YA NO SE USA, AL DESENCRIPTARLO ME DA ERROR POR COLUMNAS QUE YA NO EXISTEN (Cd_Num, Cd_Sr). COMENTARÉ LA LINEAS QUE DAN ERROR CON "ERROR_COL: ...... FIN_ERROR_COL" PARA PODER DESENCRIPTAR EL CODIGO Y PUEDAN REVISARLO

CREATE procedure [pvo].[Vta_DocsVacios]
@RucE nvarchar(11),
--@Ejer nvarchar(4),
--@PrdoIni nvarchar(2),
--@PrdoFin nvarchar(2),
@Cd_TD nvarchar(2),
@NroSre nvarchar(5),
--@NroDoc nvarchar(15),
@msj varchar(100) output

--with encryption
as



declare @Cd_Num nvarchar(7), @Min int, @Max int, @CdTD_Act nvarchar(2),	@Sre_Act nvarchar(5)
declare @a int, @b int 
declare @TVacios table
(	Cd_Num nvarchar(7) NOT NULL,
	Cd_TD nvarchar(2) NOT NULL,
	Serie nvarchar(4) NOT NULL,
	NroDoc nvarchar(15) NOT NULL 
--	Estado char(1) NOT NULL
)  

--exec sp_help 'numeracion'
--exec sp_help 'venta'

--select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and  left(RegCtb,9)='CTGN_RC01' order by left(RegCtb,9)


--if(@Cd_Fte is null or @Cd_Fte='')
--DECLARE cur_RegCtb CURSOR FOR  select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)
--else 
--DECLARE cur_RegCtb CURSOR FOR select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and Cd_Fte=@Cd_Fte /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)

--select * from serie
--select Cd_Num, Desde, Hasta from Numeracion where ruce=@RucE /*and Cd_Sr=@Cd_Sr*/ order by Cd_Num
--select * from Numeracion n, Serie s where n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr
--select n.RucE, Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr order by n.RucE, Cd_TD, NroSerie


if(@Cd_TD is null or @Cd_TD = '' ) --> consulto todos lo documentos
    DECLARE cur_NumVta CURSOR FOR select Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr order by n.RucE, Cd_TD, NroSerie
else if (@NroSre is null or @NroSre ='')
    DECLARE cur_NumVta CURSOR FOR select Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr and Cd_TD=@Cd_TD order by n.RucE, Cd_TD, NroSerie
else 
    DECLARE cur_NumVta CURSOR FOR select Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr and Cd_TD=@Cd_TD and NroSerie=@NroSre order by n.RucE, Cd_TD, NroSerie


--DECLARE cur_NumVta CURSOR FOR select Cd_Num, Desde, Hasta from Numeracion where ruce=@RucE /*and Cd_Sr=@Cd_Sr*/ order by Cd_Num
--DECLARE cur_NumVta CURSOR FOR select Cd_Num, Desde, Hasta from Numeracion where ruce='11111111111' /*and Cd_Sr=@Cd_Sr*/ order by Cd_Num


/*
select * from Numeracion order by RucE
select * from Numeracion where ruce='11111111111' order by RucE
select Cd_Num, Desde, Hasta from Numeracion where ruce='11111111111'
select * from Venta where ruce='11111111111'
select * from Venta where ruce='11111111111' and Cd_Num is null
select * from Venta where Cd_Num is null

select RucE, NroDoc from Venta where Cd_Num is null
select RucE, convert(int,NroDoc) from Venta where convert(int,NroDoc)<=0
select RucE, NroDoc from Venta where NroDoc is null
*/

OPEN cur_NumVta
	FETCH NEXT from cur_NumVta INTO @Cd_Num, @CdTD_Act, @Sre_Act, @Min, @Max --@Pref
	-- mientras haya datos
	WHILE @@FETCH_STATUS = 0
		BEGIN

		
		--print @Pref
		--set @Min = ''
		--set @Max = ''

		--set @Min = (select min(right(RegCtb,5)) from voucher where ruce=@RucE and Ejer=@Ejer and  left(RegCtb,9) = @Pref )
		--set @Max = (select max(right(RegCtb,5)) from voucher where ruce=@RucE and Ejer=@Ejer and  left(RegCtb,9) = @Pref )
		print @Min
		print @Max

		if @Min!=@Max
		begin
			
			--print '---- BUSCAMOS VACIOS PARA ' + @Cd_Num
			--print ''			

			set @a = @Min --convert(int,@Min)
			set @b = @Max
			--print @a
			--print @b			
			while(@a<@b)
			begin
				--set @a = @a + 1
				/*set @nro = ''
				set @nro = right( '00000' + ltrim(str(@a)),5)
				set @nro = @Pref + '-' + @nro
				
				if not exists (select RegCtb from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @nro)
				begin
					--print 'vacio: ' + @nro 
					insert into @TVacios values (@nro)  --,1)

				end
				*/
				
/*ERROR_COL:
				if not exists (select Cd_Vta from Venta where RucE=@RucE and Cd_Num=@Cd_Num and convert(int,NroDoc) = @a)
				begin
					--print 'vacio: ' + @nro 
					insert into @TVacios values (@Cd_Num, @CdTD_Act, @Sre_Act, @a)  --,1)
				end
FIN_ERROR_COL
*/
				set @a = @a + 1
					
			end



		end

		
		FETCH NEXT from cur_NumVta INTO @Cd_Num, @CdTD_Act, @Sre_Act, @Min, @Max --@Pref
		END
CLOSE cur_NumVta
DEALLOCATE cur_NumVta

--Si es que manejamos Columna Estado
-- select RegCtb, Case(Estado) when 1 then 'Vacio' else 'Anulado' end as Estado from @TVacios


--select Cd_Num 'CodNum', Cd_TD, Serie, NroDoc from @TVacios order by Cd_TD, Serie
--select top 100 * from venta
--select top 100 * from serie

/*
ERROR_COL:

if(@Cd_TD is null or @Cd_TD = '' ) --> consulto todos lo documentos
begin    
	select Cd_Num 'CodNum', Cd_TD, Serie, NroDoc, '' as RegCtb, 'Vacio' as Estado from @TVacios --order by Cd_TD, Serie
	union select Cd_Num, v.Cd_TD, s.NroSerie as serie, NroDoc, RegCtb, 'Anulado' as Estado   from Venta v, Serie s where v.RucE=@RucE and v.RucE = s.RucE and v.Cd_Sr = s.Cd_Sr and IB_Anulado=1 order by Cd_TD, Serie
end
else if (@NroSre is null or @NroSre ='')
begin
	select Cd_Num 'CodNum', Cd_TD, Serie, NroDoc, '' as RegCtb, 'Vacio' as Estado from @TVacios --order by Cd_TD, Serie
	union select Cd_Num, v.Cd_TD, s.NroSerie as serie, NroDoc, RegCtb, 'Anulado' as Estado   from Venta v, Serie s where v.RucE=@RucE and v.Cd_TD=@Cd_TD and v.RucE = s.RucE and v.Cd_Sr = s.Cd_Sr and IB_Anulado=1 order by Cd_TD, Serie
end
else 
begin
	select Cd_Num 'CodNum', Cd_TD, Serie, NroDoc, '' as RegCtb, 'Vacio' as Estado from @TVacios --order by Cd_TD, Serie
	union select Cd_Num, v.Cd_TD, s.NroSerie as serie, NroDoc, RegCtb, 'Anulado' as Estado   from Venta v, Serie s where v.RucE=@RucE and v.Cd_TD=@Cd_TD and NroSerie=@NroSre and v.RucE = s.RucE and v.Cd_Sr = s.Cd_Sr and IB_Anulado=1 order by Cd_TD, Serie
end

FIN_ERROR_COL */

/*
if(@Cd_Fte is null or @Cd_Fte='')
begin	select RegCtb, 'Vacio' Estado from @TVacios
	union select Distinct(RegCtb), 'Anulado' Estado from voucher where RucE=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and IB_Anulado=1 order by RegCtb
end
else 
begin	select RegCtb, 'Vacio' Estado from @TVacios
	union select Distinct(RegCtb), 'Anulado' Estado from voucher where RucE=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and Cd_Fte=@Cd_Fte and IB_Anulado=1 order by RegCtb
end
*/


-- PUERBAS ----

/*
select * from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01'
select distinct(RegCtb) from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01' order by RegCtb
select min(RegCtb) from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01'
select max(RegCtb) from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01'



exec pvo.Vta_DocsVacios '11111111111','','',null
exec pvo.Vta_DocsVacios '11111111111','01','',null
exec pvo.Vta_DocsVacios '11111111111','01','0001',null

*/




--PV: Lun 10/08/2009 Creado
--PV: Mie 12/08/2009 Mdf: mejorado
--PV: Vie 11/05/2010 Creado
--PV: Jue 20/05/2010 Terminado

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****



GO
