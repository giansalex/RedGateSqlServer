SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_RegCtbVacios]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Cd_Fte nvarchar(2),
--@RegCtb nvarchar(15),
@msj varchar(100) output
as

declare @Pref varchar(9), @Min varchar(5), @Max varchar(5), @nro varchar(15)
declare @a int, @b int 
declare @TVacios table
(	RegCtb nvarchar(15) NOT NULL --,
--	Estado char(1) NOT NULL
)  



--select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and  left(RegCtb,9)='CTGN_RC01' order by left(RegCtb,9)
if(@Cd_Fte is null or @Cd_Fte='')
DECLARE cur_RegCtb CURSOR FOR  select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)
else 
DECLARE cur_RegCtb CURSOR FOR select distinct(left(RegCtb,9))as Lista_Registros from voucher where ruce=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and Cd_Fte=@Cd_Fte /*and  left(RegCtb,9)='CTGN_RC01'*/ order by left(RegCtb,9)
OPEN cur_RegCtb
	FETCH NEXT from cur_RegCtb INTO @Pref
	-- mientras haya datos
	WHILE @@FETCH_STATUS = 0
		BEGIN

		
		--print @Pref
		set @Min = ''
		set @Max = ''

		set @Min = (select min(right(RegCtb,5)) from voucher where ruce=@RucE and Ejer=@Ejer and  left(RegCtb,9) = @Pref )
		set @Max = (select max(right(RegCtb,5)) from voucher where ruce=@RucE and Ejer=@Ejer and  left(RegCtb,9) = @Pref )
		--print @Min
		--print @Max

		if @Min!=@Max
		begin
			
			--print '---- BUSCAMOS VACIOS PARA ' + @Pref
			--print ''			

			set @a = convert(int,@Min)
			set @b = @Max


			--print @a
			--print @b
			
			while(@a<@b)
			begin
				set @a = @a + 1
				set @nro = ''
				set @nro = right( '00000' + ltrim(str(@a)),5)
				set @nro = @Pref + '-' + @nro
				
				if not exists (select RegCtb from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @nro)
				begin
					--print 'vacio: ' + @nro 
					insert into @TVacios values (@nro)  --,1)

				end
									
			end



		end

		
		FETCH NEXT from cur_RegCtb INTO @Pref
		END
CLOSE cur_RegCtb
DEALLOCATE cur_RegCtb

--Si es que manejamos Columna Estado
-- select RegCtb, Case(Estado) when 1 then 'Vacio' else 'Anulado' end as Estado from @TVacios


if(@Cd_Fte is null or @Cd_Fte='')
begin	select RegCtb, 'Vacio' Estado from @TVacios
	union select Distinct(RegCtb), 'Anulado' Estado from voucher where RucE=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and IB_Anulado=1 order by RegCtb
end
else 
begin	select RegCtb, 'Vacio' Estado from @TVacios
	union select Distinct(RegCtb), 'Anulado' Estado from voucher where RucE=@RucE and Ejer=@Ejer and Prdo>=@PrdoIni and Prdo<=@PrdoFin and Cd_Fte=@Cd_Fte and IB_Anulado=1 order by RegCtb
end

-- PUERBAS ----

/*
select * from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01'
select distinct(RegCtb) from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01' order by RegCtb
select min(RegCtb) from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01'
select max(RegCtb) from voucher where ruce='11111111111' and Ejer='2009' and  left(RegCtb,9) = 'CTGN_RC01'

exec pvo.Ctb_RegCtbVacios '11111111111','2009','00','09','',null
exec pvo.Ctb_RegCtbVacios '20512635025','2009','01','01','CB',null

exec pvo.Ctb_RegCtbVacios '20512635025','2009','00','09','',null --> 52,51 seg

exec pvo.Ctb_RegCtbVacios '20512635025','2009','05','05','',null    ---> 3seg
  exec pvo.Ctb_RegCtbVacios '20512635025','2009','05','05','CB',null
  exec pvo.Ctb_RegCtbVacios '20512635025','2009','05','05','RV',null


*/




--PV: Lun 10/08/2009 Creado
--PV: Mie 12/08/2009 Mdf: mejorado

GO
