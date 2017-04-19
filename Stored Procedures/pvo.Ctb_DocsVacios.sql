SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****

CREATE procedure [pvo].[Ctb_DocsVacios]
@RucE nvarchar(11),
--@Ejer nvarchar(4),
--@PrdoIni nvarchar(2),
--@PrdoFin nvarchar(2),
@Cd_TD nvarchar(2),
@NroSre nvarchar(5),
--@NroDoc nvarchar(15),
@IB_Vacios bit,
@IB_Anulados bit,
@msj varchar(100) output

--with encryption
as



declare @Consec int --Consecutivos
declare @ProxDoc bigint --Minimo Proximo NroDoc
declare @TDocsTemp table
(	Cd_TD nvarchar(2) NOT NULL,
	Serie nvarchar(4) NOT NULL,
	NroDoc bigint--nvarchar(15) NOT NULL 
)  


declare  @Min bigint, @Max bigint, @CdTD_Act nvarchar(2),@Sre_Act nvarchar(5)
declare @a bigint, @b bigint 
declare @TVacios table
(	Cd_TD nvarchar(2) NOT NULL,
	Serie nvarchar(4) NOT NULL,
	NroDoc bigint NOT NULL, --NroDoc nvarchar(15) NOT NULL,
	ContinuaAl bigint NULL
--	Estado char(1) NOT NULL
)  


--exec sp_help 'numeracion'
--exec sp_help 'venta'

--select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and  left(RegCtb,9)='CTGN_RC01' order by left(RegCtb,9)


--if(@Cd_Fte is null or @Cd_Fte='')
--DECLARE cur_RegCtb CURSOR FOR  select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)
--else 
--DECLARE cur_RegCtb CURSOR FOR select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and Cd_Fte=@Cd_Fte /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)

/*
declare @RucE nvarchar(11), @Cd_TD nvarchar(2), @NroSre nvarchar(5)
--set @RucE='11111111111'
set @RucE='20512635025'
set @Cd_TD='01'
set @NroSre='0000'

--select min(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
--select max(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
	
	


/ *
declare @TDocsTemp table
(	Cd_TD nvarchar(2) NOT NULL,
	Serie nvarchar(4) NOT NULL,
	NroDoc nvarchar(15) NOT NULL 
)

--(No Funciona)select Cd_TD, NroSre, convert(int,NroDoc) into @TDocsTemp from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(int,NroDoc) /*order by Cd_TD, NroSre, convert(int,NroDoc)*/ --NroDocs sin duplicados (excluyendo ceros)
--(Funciona) insert into @TDocsTemp  select Cd_TD, NroSre, convert(int,NroDoc) as NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(int,NroDoc) /*order by Cd_TD, NroSre, convert(int,NroDoc)*/ --NroDocs sin duplicados (excluyendo ceros)
--(Funciona) insert into @TDocsTemp (Cd_TD, Serie, NroDoc) select Cd_TD, NroSre, convert(int,NroDoc) as NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(int,NroDoc) /*order by Cd_TD, NroSre, convert(int,NroDoc)*/ --NroDocs sin duplicados (excluyendo ceros)
--insert into @TDocsTemp (Cd_TD, Serie, NroDoc) select Cd_TD, NroSre, convert(int,NroDoc) as NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(int,NroDoc) /*order by Cd_TD, NroSre, convert(int,NroDoc)*/ --NroDocs sin duplicados (excluyendo ceros)
 --select * from  @TDocsTemp


  --select NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 /*and convert(int,NroDoc) = @a*/ order by Cd_TD, NroSre, convert(int,NroDoc)
  --select NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 /*and convert(int,NroDoc) = @a*/ group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)

  --Tres formas de excluir NroDocs:
  --(utilizamos esta para intertar en @TDocsTemp)select Cd_TD, NroSre, convert(int,NroDoc) as NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(int,NroDoc) order by Cd_TD, NroSre, convert(int,NroDoc) --NroDocs sin duplicados (excluyendo ceros)
  --select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc) --NroDocs sin duplicados (sin excluir ceros)
  --select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 /*group by Cd_TD, NroSre*/ order by Cd_TD, NroSre, convert(int,NroDoc) --NroDocs con duplicados


  --INTENTOS PARA NO USAR TABLA TEMP DOC QUE SE PUEDAN CONVERTIR A ENTERO
  --select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and NroDoc='anulado'
  --select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc) --NroDocs sin duplicados (sin excluir ceros)
  --(No Funciona) select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, NroDoc having convert(int,NroDoc)=1 order by Cd_TD, NroSre, convert(int,NroDoc) --NroDocs sin duplicados (sin excluir ceros)
  --(No Funciona) select Cd_TD, NroSre, NroDoc as aa from (select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, NroDoc /* order by Cd_TD, NroSre*/) as voucherx where convert(int,voucherx.NroDoc)=1 order by convert(int,voucherx.NroDoc)


--  select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 /*group by Cd_TD, NroSre*/ order by Cd_TD, NroSre, convert(int,NroDoc)
--  select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 /*group by Cd_TD, NroSre*/ order by Cd_TD, NroSre, convert(int,NroDoc)
--select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 /*group by Cd_TD, NroSre*/ order by Cd_TD, NroSre, convert(int,NroDoc)
--select Cd_TD, NroSre, convert(int,NroDoc) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
--select min(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
--select max(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)

*/

--select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and Cd_Fte=@Cd_Fte /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)
--select RucE, RegCtb, Cd_TD, NroSre, NroDoc, IB_Anulado from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc is not null and NroDoc != '' order by RegCtb, Cd_TD, NroSre
--1)TODOS LOS NROSDOCS VALIDABLES: 6558
--select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc is not null and NroDoc != '' group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, NroDoc


--1.1)TODOS LOS QUE SE PUEDEN CONVERTIR A ENTEROS: 6451
  --select Cd_TD, NroSre, convert(bigint,NroDoc) from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, NroDoc
--1.2)TODOS LOS QUE TIENEN CARACTERES Y PUNTO DECIMAL: (OBSERVADOS) 107
  --select Cd_TD, NroSre, NroDoc from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc is not null and NroDoc != '' and (isnumeric(NroDoc)=0 or NroDoc like '%.%') group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, NroDoc


--1.11)GRUPOS DE SERIES NULLAS Y NO NULAS QUE SE VAN A VALIDAR: 450
  --select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre

  --1.11A)Series no nulas: 440
    --1.11A1)Todos: 440
	--select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and (NroSre is not null and NroSre!='') and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre
	--select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and (NroSre is not null and NroSre!='') and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre
    --1.11A2)con TD 01: 86
	--select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD =@Cd_TD and (NroSre is not null and NroSre!='') and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre
    --1.11A3)con Cd_TD y Serie 001: 1
	--select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre

  --1.11B)Series nulas o en blanco: 10
    --select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 and (NroSre is null or NroSre='') group by Cd_TD, NroSre order by Cd_TD, NroSre




--select *  from voucher where ruce=@RucE 


/*
if(@Cd_TD is null or @Cd_TD = '' ) --> consulto todos lo documentos
    DECLARE cur_NumVta CURSOR FOR select Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr order by n.RucE, Cd_TD, NroSerie
else if (@NroSre is null or @NroSre ='')
    DECLARE cur_NumVta CURSOR FOR select Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr and Cd_TD=@Cd_TD order by n.RucE, Cd_TD, NroSerie
else 
    DECLARE cur_NumVta CURSOR FOR select Cd_Num, Cd_TD, NroSerie, Desde, Hasta  from Numeracion n, Serie s where n.RucE=@RucE and n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr and Cd_TD=@Cd_TD and NroSerie=@NroSre order by n.RucE, Cd_TD, NroSerie
*/
	
if @IB_Vacios=1
begin

	print 'ENTRANDO A CURSOR'
	
	
	if(@Cd_TD is null or @Cd_TD = '' ) --> consulto todos lo documentos
	    DECLARE cur_NumCtb CURSOR FOR select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD is not null and Cd_TD !='' and (NroSre is not null and NroSre!='') and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre
	else if (@NroSre is null or @NroSre ='')
	    DECLARE cur_NumCtb CURSOR FOR select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD =@Cd_TD and (NroSre is not null and NroSre!='') and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre
	else 
	    DECLARE cur_NumCtb CURSOR FOR select Cd_TD, NroSre from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre order by Cd_TD, NroSre
	
	
	
	OPEN cur_NumCtb
		FETCH NEXT from cur_NumCtb INTO @CdTD_Act, @Sre_Act
		-- mientras haya datos
		WHILE @@FETCH_STATUS = 0
			BEGIN
			print 'Cd_TD: '+ @CdTD_Act + ', Serie: '+ @Sre_Act
			
			--print @Pref
			set @Min = ''
			set @Max = ''
	
			--set @Min = (select min(right(RegCtb,5)) from voucher where ruce=@RucE and Ejer=@Ejer and  left(RegCtb,9) = @Pref )
			--set @Max = (select max(right(RegCtb,5)) from voucher where ruce=@RucE and Ejer=@Ejer and  left(RegCtb,9) = @Pref )
			--set @Min = (select min(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1) --group by Cd_TD, NroSre order by Cd_TD, NroSre
			--set @Max = (select max(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1) --group by Cd_TD, NroSre order by Cd_TD, NroSre
			select @Min = min(convert(bigint,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@CdTD_Act and NroSre=@Sre_Act and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
			select @Max = max(convert(bigint,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@CdTD_Act and NroSre=@Sre_Act and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
			--select @Max = (select max(convert(int,NroDoc)) from voucher where ruce=@RucE and Cd_TD =@CdTD_Act and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 )--group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
	
			print 'Minimo: ' + convert(varchar,@Min)
			print 'Maximo: ' + convert(varchar,@Max)
							
			Print 'INSERTAMOS EN LA TABLA TEMPORAL '+@CdTD_Act+', '+@Sre_Act
			delete @TDocsTemp
			insert into @TDocsTemp (Cd_TD, Serie, NroDoc) select Cd_TD, NroSre, convert(bigint,NroDoc) as NroDoc from voucher where ruce=@RucE and Cd_TD =@CdTD_Act and NroSre=@Sre_Act and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(bigint,NroDoc) /*order by Cd_TD, NroSre, convert(int,NroDoc)*/ --NroDocs sin duplicados (excluyendo ceros)
			--insert into @TDocsTemp from select Cd_TD, NroSre, convert(int,NroDoc) as NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 group by Cd_TD, NroSre, convert(int,NroDoc) order by Cd_TD, NroSre, convert(int,NroDoc) --NroDocs sin duplicados (excluyendo ceros)
	  
	
	
			if @Min!=@Max
			begin
				
				--print '---- BUSCAMOS VACIOS PARA ' + @Cd_Num
				--print ''			
	
				set @a = @Min --convert(int,@Min)
				set @b = @Max
				--print @a
				--print @b	
			
				while(@a<@b)-- and @a<=5000)
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
					
				      --if not exists (select NroDoc from voucher where RucE=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and convert(int,NroDoc) = @a)
				      --if not exists (select NroDoc from voucher where ruce=@RucE and Cd_TD =@Cd_TD and NroSre=@NroSre and NroDoc is not null and NroDoc != '' and NroDoc not like '%.%' and isnumeric(NroDoc)=1 and convert(int,NroDoc) = @a) --group by Cd_TD, NroSre, NroDoc order by Cd_TD, NroSre, convert(int,NroDoc)
				      if not exists (select NroDoc from @TDocsTemp where Cd_TD =@CdTD_Act and Serie=@Sre_Act and NroDoc = @a) 
					begin
						--print 'vacio: ' + convert(varchar,@a) 
						insert into @TVacios values (@CdTD_Act, @Sre_Act, @a, null)  --,1)
						set @Consec = @Consec + 1
	
	
					      	if (@Consec>=5) 
						begin
							--print 'vacios sucesivos a : ' + convert(varchar,@a) 
							--declare @minND int 
							--set @minND = (select min(convert(int,NroDoc)) from @TDocsTemp where Cd_TD=@CdTD_Act and Serie=@Sre_Act and convert(int,NroDoc)> @a)
							set @ProxDoc = (select min(NroDoc) from @TDocsTemp where Cd_TD=@CdTD_Act and Serie=@Sre_Act and NroDoc> @a)
							--print 'Minimo mas proximo : ' + convert(varchar,@ProxDoc) 
							
							update @TVacios set ContinuaAl = @ProxDoc-1 where Cd_TD=@CdTD_Act and Serie=@Sre_Act and NroDoc = @a --convert(varchar,NroDoc)= @a
							set @Consec = 0
		
							
							set @a = @ProxDoc
						end
	
	
					end
				      else	set @Consec = 0
	
	
	
	/*
	
				      if (@Consec>=5) 
					begin
						print 'vacios sucesivos a : ' + convert(varchar,@a) 
						--declare @minND int 
						--set @minND = (select min(convert(int,NroDoc)) from @TDocsTemp where Cd_TD=@CdTD_Act and Serie=@Sre_Act and convert(int,NroDoc)> @a)
						set @ProxDoc = (select min(NroDoc) from @TDocsTemp where Cd_TD=@CdTD_Act and Serie=@Sre_Act and NroDoc> @a)
						print 'Minimo mas proximo : ' + convert(varchar,@ProxDoc) 
						
						update @TVacios set ContinuaAl = @ProxDoc-1 where Cd_TD=@CdTD_Act and Serie=@Sre_Act and convert(varchar,NroDoc)= @a
						set @Consec = 0
	
						
						set @a = @ProxDoc
					end
	*/
				      --else	
						set @a = @a + 1
	
	
	--				set @a = @a + 1
						
				end --while
	
	
	
			end --if @Min!=@Max
	
			
			FETCH NEXT from cur_NumCtb INTO @CdTD_Act, @Sre_Act
			END
	CLOSE cur_NumCtb
	DEALLOCATE cur_NumCtb

end --if @IB_Vacios=1



--Si es que manejamos Columna Estado
-- select RegCtb, Case(Estado) when 1 then 'Vacio' else 'Anulado' end as Estado from @TVacios




--Tabla Docs Emitidos:
--select Cd_TD, Serie, NroDoc as NDocTemp from @TDocsTemp order by Cd_TD, Serie, convert(int,NroDoc)
--Tabla Docs Vacios:
--select Cd_TD, Serie, NroDoc as NDocVacios, ContinuaAl from @TVacios order by Cd_TD, Serie, convert(int,NroDoc)

--select top 10 * from voucher where Cd_TD is not null and Cd_TD !='' and IB_Anulado=1

/*
exec pvo.Ctb_DocsVacios '11111111111','','',null  
exec pvo.Ctb_DocsVacios '11111111111','01','',null -- ok
exec pvo.Ctb_DocsVacios '11111111111','01','0001',null --ok

exec pvo.Ctb_DocsVacios '11111111111','01','',0,0,null  
exec pvo.Ctb_DocsVacios '11111111111','01','',1,0,null  
exec pvo.Ctb_DocsVacios '11111111111','01','',0,1,null  
exec pvo.Ctb_DocsVacios '11111111111','01','',1,1,null  


exec pvo.Ctb_DocsVacios '11111111111','01','',null -- ok
exec pvo.Ctb_DocsVacios '11111111111','01','0001',null --ok


select * from voucher where RucE='11111111111' and RegCtb='VTGE_RV01-00003' and Cd_Vou=14699
update voucher set NroDoc='00052x' where RucE='11111111111' and RegCtb='VTGE_RV01-00003' and Cd_Vou=14699
01	0001	52	NULL	VTGE_RV01-00003	Anulado
*/



--/*
if @IB_Vacios=1 and @IB_Anulados=0
begin
	select Cd_TD, Serie, NroDoc, ContinuaAl, '' as RegCtb, 'Vacio' as Estado from @TVacios order by Cd_TD, Serie, NroDoc
end

else if @IB_Vacios=1 and @IB_Anulados=1
begin
	if(@Cd_TD is null or @Cd_TD = '' ) --> consulto todos lo documentos anulados + todos los vacios encontrados
	begin    
		select Cd_TD, Serie, NroDoc, ContinuaAl, '' as RegCtb, 'Vacio' as Estado from @TVacios --order by Cd_TD, Serie
		union select Cd_TD, NroSre as Serie, NroDoc, null as ContinuaAl, RegCtb, 'Anulado' as Estado   from Voucher where RucE=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc not like '%.%' and  isnumeric(NroDoc)=1 and IB_Anulado=1 order by Cd_TD, Serie, NroDoc
	end
	else if (@NroSre is null or @NroSre ='') --> consulto anulados de un Cd_TD + todos los vacios encontrados
	begin
		select Cd_TD, Serie, NroDoc, ContinuaAl, '' as RegCtb, 'Vacio' as Estado from @TVacios --order by Cd_TD, Serie
		union select Cd_TD, NroSre as Serie, NroDoc, null as ContinuaAl, RegCtb, 'Anulado' as Estado   from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroDoc not like '%.%' and  isnumeric(NroDoc)=1 and IB_Anulado=1 order by Cd_TD, Serie, NroDoc
	end
	else 	--> consulto anulados de un Cd_TD y Serie + todos los vacios encontrados
	begin
		select Cd_TD, Serie, NroDoc, ContinuaAl, '' as RegCtb, 'Vacio' as Estado from @TVacios --order by Cd_TD, Serie
		union select Cd_TD, NroSre as Serie, NroDoc, null as ContinuaAl, RegCtb, 'Anulado' as Estado   from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc not like '%.%' and  isnumeric(NroDoc)=1 and IB_Anulado=1 order by Cd_TD, Serie, NroDoc
	end
end

else if @IB_Vacios=0 and @IB_Anulados=1
begin
	if(@Cd_TD is null or @Cd_TD = '' ) --> consulto todos lo documentos anulados + todos los vacios encontrados
	begin    
		select Cd_TD, NroSre as Serie, NroDoc, null as ContinuaAl, RegCtb, 'Anulado' as Estado   from Voucher where RucE=@RucE and Cd_TD is not null and Cd_TD !='' and NroDoc not like '%.%' and  isnumeric(NroDoc)=1 and IB_Anulado=1 order by Cd_TD, Serie, NroDoc
	end
	else if (@NroSre is null or @NroSre ='') --> consulto anulados de un Cd_TD + todos los vacios encontrados
	begin
		select Cd_TD, NroSre as Serie, NroDoc, null as ContinuaAl, RegCtb, 'Anulado' as Estado   from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroDoc not like '%.%' and  isnumeric(NroDoc)=1 and IB_Anulado=1 order by Cd_TD, Serie, NroDoc
	end
	else 	--> consulto anulados de un Cd_TD y Serie + todos los vacios encontrados
	begin
		select Cd_TD, NroSre as Serie, NroDoc, null as ContinuaAl, RegCtb, 'Anulado' as Estado   from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc not like '%.%' and  isnumeric(NroDoc)=1 and IB_Anulado=1 order by Cd_TD, Serie, NroDoc
	end
end



--*/



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



exec pvo.Ctb_DocsVacios '20512635025','','',null
exec pvo.Vta_DocsVacios '20512635025','01','',null
exec pvo.Vta_DocsVacios '20512635025','01','001',null
----------------------------------------------------


exec pvo.Ctb_DocsVacios '20512635025','01','',null

exec pvo.Ctb_DocsVacios '20512635025','01','001',null
exec pvo.Ctb_DocsVacios '20512635025','01','002',null
exec pvo.Ctb_DocsVacios '20512635025','01','0100',null
exec pvo.Ctb_DocsVacios '20512635025','01','c',null
exec pvo.Ctb_DocsVacios '20512635025','01','JGC',null
exec pvo.Ctb_DocsVacios '20512635025','01','0',null
exec pvo.Ctb_DocsVacios '20512635025','01','0000',null

01	0
01	0000
01	0001
01	0002
01	001
01	0019
01	002
...	...
01	878
01	980
01	C
01	JGC
01	PRES
01	RV08
01	RV09
01	RV10

*/




--PV: Lun 10/08/2009 Creado
--PV: Mie 12/08/2009 Mdf: mejorado
--PV: Vie 11/05/2010 Creado
--PV: Jue 20/05/2010 Terminado
--PV: Lun 31/05/2010 mejorado
--PV: Mar 01/06/2010 mejorado

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****
GO
