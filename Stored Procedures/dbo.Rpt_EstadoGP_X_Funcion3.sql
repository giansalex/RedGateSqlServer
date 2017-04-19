SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EstadoGP_X_Funcion3]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@n1 bit,
@n2 bit,
@n3 bit,
@n4 bit,
@Cd_Mda nvarchar(2),

@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Datos  nvarchar(4000),

@NroCtaD nvarchar(10),
@NroCtaH nvarchar(10),
@msj varchar(100) output
as

Declare @Mda nvarchar(3),@ColMda nvarchar(3)
Declare @RangoCC nvarchar(4000)
Declare @RangoD1 nvarchar(100),@RangoD2 nvarchar(100),@RangoD3 nvarchar(100),@RangoD4 nvarchar(100)
Declare @RangoH1 nvarchar(100),@RangoH2 nvarchar(100),@RangoH3 nvarchar(100),@RangoH4 nvarchar(100)
Declare @IndCS nvarchar(20)

Set @Mda=''     --Indicador para identificar el tipo de moneda
Set @ColMda=''  --Indicador para identificar el tipo de columna de acuerdo al tipo de moneda ingresado
Set @RangoCC='' --Indicador para identificar el las condicionales para los valores a CC,SC,SS
Set @RangoD1='' Set @RangoD2='' Set @RangoD3='' Set @RangoD4=''
Set @RangoH1='' Set @RangoH2='' Set @RangoH3='' Set @RangoH4=''
Set @IndCS=''

Set @Mda = (Case(@Cd_Mda) when '02' then '_D' else '' end)

if(isnull(len(@NroCtaD),0) = 0) 
	set @NroCtaD = '0000000000'
else
Begin 
	if(len(@NroCtaD) = 2)
	Begin	
		Set @RangoD1 = ' and left(s.NroCtaN1,2)>='''+@NroCtaD+''''
		Set @RangoD2 = ' and left(s.NroCtaN2,2)>='''+@NroCtaD+''''
		Set @RangoD3 = ' and left(s.NroCtaN3,2)>='''+@NroCtaD+''''
		Set @RangoD4 = ' and left(s.NroCtaN4,2)>='''+@NroCtaD+''''
	End
	else if(len(@NroCtaD) = 4)
	Begin   Set @RangoD1 = ' and left(s.NroCtaN1,4)>='''+@NroCtaD+''''
		Set @RangoD2 = ' and left(s.NroCtaN2,4)>='''+@NroCtaD+''''
		Set @RangoD3 = ' and left(s.NroCtaN3,4)>='''+@NroCtaD+''''
		Set @RangoD4 = ' and left(s.NroCtaN4,4)>='''+@NroCtaD+''''
	End
	else if(len(@NroCtaD) = 6) 	
	Begin   Set @RangoD1 = ' and left(s.NroCtaN1,6)>='''+@NroCtaD+''''
		Set @RangoD2 = ' and left(s.NroCtaN2,6)>='''+@NroCtaD+''''
		Set @RangoD3 = ' and left(s.NroCtaN3,6)>='''+@NroCtaD+''''
		Set @RangoD4 = ' and left(s.NroCtaN4,6)>='''+@NroCtaD+''''
	End
	else
	Begin   Set @RangoD1 = ' and s.NroCtaN1>='''+@NroCtaD+''''
		Set @RangoD2 = ' and s.NroCtaN2>='''+@NroCtaD+''''
		Set @RangoD3 = ' and s.NroCtaN3>='''+@NroCtaD+''''
		Set @RangoD4 = ' and s.NroCtaN4>='''+@NroCtaD+''''
	End
End
if(isnull(len(@NroCtaH),0) = 0) 
	set @NroCtaH = '9999999999'
else
Begin 
	if(len(@NroCtaH) = 2)
	Begin	
		Set @RangoH1 = ' and left(s.NroCtaN1,2)<='''+@NroCtaH+''''
		Set @RangoH2 = ' and left(s.NroCtaN2,2)<='''+@NroCtaH+''''
		Set @RangoH3 = ' and left(s.NroCtaN3,2)<='''+@NroCtaH+''''
		Set @RangoH4 = ' and left(s.NroCtaN4,2)<='''+@NroCtaH+''''
	End
	else if(len(@NroCtaH) = 4)
	Begin   Set @RangoD1 = ' and left(s.NroCtaN1,4)<='''+@NroCtaH+''''
		Set @RangoD2 = ' and left(s.NroCtaN2,4)<='''+@NroCtaH+''''
		Set @RangoD3 = ' and left(s.NroCtaN3,4)<='''+@NroCtaH+''''
		Set @RangoD4 = ' and left(s.NroCtaN4,4)<='''+@NroCtaH+''''
	End
	else if(len(@NroCtaH) = 6) 	
	Begin   Set @RangoH1 = ' and left(s.NroCtaN1,6)<='''+@NroCtaH+''''
		Set @RangoH2 = ' and left(s.NroCtaN2,6)<='''+@NroCtaH+''''
		Set @RangoH3 = ' and left(s.NroCtaN3,6)<='''+@NroCtaH+''''
		Set @RangoH4 = ' and left(s.NroCtaN4,6)<='''+@NroCtaH+''''
	End
	else
	Begin   Set @RangoH1 = ' and s.NroCtaN1<='''+@NroCtaH+''''
		Set @RangoH2 = ' and s.NroCtaN2<='''+@NroCtaH+''''	
		Set @RangoH3 = ' and s.NroCtaN3<='''+@NroCtaH+''''
		Set @RangoH4 = ' and s.NroCtaN4<='''+@NroCtaH+''''
	End
End

--**************************************************************************************

if(isnull(len(@Cd_CC),'0') <> '0') --CENTRO COSTOS
begin
	Set @IndCS = '_conSS'
	Set @RangoCC = ' and s.Cd_CC='''+@Cd_CC+''''
	if(isnull(len(@Cd_SC),'0') <> '0')  --SUB CENTRO COSTOS
	begin
		Set @RangoCC = @RangoCC + ' and s.Cd_SC='''+@Cd_SC+''''
		if(isnull(len(@Cd_SS),'0') <> '0')  --SUB SUB CENTRO COSTOS
		begin
			Set @RangoCC = @RangoCC +' and s.Cd_SS='''+@Cd_SS+''''
		end
		else if(isnull(len(@Datos),'0') <> '0')
			Set @RangoCC = @RangoCC + ' and s.Cd_SS in ('+@Datos+')'
	end
	else if(isnull(len(@Datos),'0') <> '0')
		Set @RangoCC = @RangoCC + ' and s.Cd_SC in ('+@Datos+')'
end
else if(isnull(len(@Datos),'0') <> '0')
begin
	Set @IndCS = '_conSS'
	Set @RangoCC = ' and s.Cd_CC in ('+@Datos+')'
end
else	Set @RangoCC=''

--**************************************************************************************


Declare @i int
Declare @Mes nvarchar(10)
Declare @Colum0 varchar(2000), @ColumT varchar(500), @Suma varchar(500), @SumaT varchar(500)
Declare @Sum00 varchar(2000), @Sum01 varchar(2000), @Sum02 varchar(2000), @Sum03 varchar(2000), @Sum04 varchar(2000), @Sum05 varchar(2000), @Sum06 varchar(2000)
Declare @Sum07 varchar(2000), @Sum08 varchar(2000), @Sum09 varchar(2000), @Sum10 varchar(2000), @Sum11 varchar(2000), @Sum12 varchar(2000), @Sum13 varchar(2000), @Sum14 varchar(2000)
Declare @T100 nvarchar(3000), @T101 nvarchar(3000), @T102 nvarchar(3000), @T103 nvarchar(3000), @T104 nvarchar(3000), @T105 nvarchar(3000), @T106 nvarchar(3000)
Declare @T107 nvarchar(3000),  @T108 nvarchar(3000), @T109 nvarchar(3000), @T110 nvarchar(3000), @T111 nvarchar(3000), @T112 nvarchar(3000), @T113 nvarchar(3000), @T114 nvarchar(3000)
Declare @TG1 nvarchar(4000), @TG2 nvarchar(4000), @TG3 nvarchar(4000)
Declare @T200 nvarchar(1000), @T201 nvarchar(1000), @T202 nvarchar(1000), @T203 nvarchar(1000), @T204 nvarchar(1000), @T205 nvarchar(1000), @T206 nvarchar(1000)
Declare @T207 nvarchar(1000),  @T208 nvarchar(1000), @T209 nvarchar(1000), @T210 nvarchar(1000), @T211 nvarchar(1000), @T212 nvarchar(1000), @T213 nvarchar(1000), @T214 nvarchar(1000)

Declare @T300 nvarchar(1000), @T301 nvarchar(1000), @T302 nvarchar(1000), @T303 nvarchar(1000), @T304 nvarchar(1000), @T305 nvarchar(1000), @T306 nvarchar(1000)
Declare @T307 nvarchar(1000),  @T308 nvarchar(1000), @T309 nvarchar(1000), @T310 nvarchar(1000), @T311 nvarchar(1000), @T312 nvarchar(1000), @T313 nvarchar(1000), @T314 nvarchar(1000)

Set @Colum0 = '' Set @ColumT = '' Set @Suma = '' Set @SumaT = '' Set @i = 0 Set @Mes = ''
Set @Sum00='' Set @Sum01='' Set @Sum02='' Set @Sum03='' Set @Sum04='' Set @Sum05='' Set @Sum06='' Set @Sum07='' Set @Sum08='' Set @Sum09='' Set @Sum10='' Set @Sum11='' Set @Sum12='' Set @Sum13='' Set @Sum14=''
Set @T100='' Set @T101='' Set @T102='' Set @T103='' Set @T104='' Set @T105='' Set @T106='' Set @T107='' Set @T108='' Set @T109='' Set @T110='' Set @T111='' Set @T112='' Set @T113='' Set @T114=''
Set @T200='' Set @T201='' Set @T202='' Set @T203='' Set @T204='' Set @T205='' Set @T206='' Set @T207='' Set @T208='' Set @T209='' Set @T210='' Set @T211='' Set @T212='' Set @T213='' Set @T214=''
Set @T300='' Set @T301='' Set @T302='' Set @T303='' Set @T304='' Set @T305='' Set @T306='' Set @T307='' Set @T308='' Set @T309='' Set @T310='' Set @T311='' Set @T312='' Set @T313='' Set @T314=''
Set @TG1='' Set @TG2='' Set @TG3=''

Set @i = Convert(int,@PrdoIni)
Set @PrdoFin = Convert(int,@PrdoFin)

while(@i <= @PrdoFin and @i < 10)
begin
	if(@i = 0)
	Begin	Set @Mes = 'INICIAL'
		--Set @Sum00 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo00)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo00))) end as '+@Mes--',Abs(Sum(s.Saldo00)) as '+@Mes
		Set @Sum00 = ',Case(Sum(s.Saldo00)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo00)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo00))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo00)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo00)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo00)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo00))) end end end as '+@Mes
		Set @T100 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo00)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo00) else 0 end)
			     )) as '+@Mes
		Set @T200 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo00)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo00) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo00) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo00) else 0 end)
			     )) as '+@Mes
		Set @T300 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo00)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo00) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo00) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo00) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo00) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo00) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo00) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo00) else 0 end)
			     )) as '+@Mes
	End 
	if(@i = 1)
	Begin	Set @Mes = 'ENE'
		--Set @Sum01 =  ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo01)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo01))) end as '+@Mes--',Abs(Sum(s.Saldo01)) as '+@Mes
		Set @Sum01 = ',Case(Sum(s.Saldo01)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo01)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo01))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo01)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo01)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo01)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo01))) end end end as '+@Mes
		Set @T101 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo01)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo01) else 0 end)
			     )) as '+@Mes
		Set @T201 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo01)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then Abs(s.Saldo01) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then Abs(s.Saldo01) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then Abs(s.Saldo01) else 0 end)
			     )) as '+@Mes
		Set @T301 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo01)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo01) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo01) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo01) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo01) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo01) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo01) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo01) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 2)
	Begin	Set @Mes = 'FEB'
		--Set @Sum02 =  ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo02)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo02))) end as '+@Mes--',Abs(Sum(s.Saldo02)) as '+@Mes
		Set @Sum02 = ',Case(Sum(s.Saldo02)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo02)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo02))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo02)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo02)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo02)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo02))) end end end as '+@Mes
		Set @T102 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo02)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo02) else 0 end)
			     )) as '+@Mes
		Set @T202 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo02)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo02) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo02) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo02) else 0 end)
			     )) as '+@Mes
		Set @T302 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo02)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo02) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo02) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo02) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo02) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo02) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo02) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo02) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 3)
	Begin	Set @Mes = 'MAR'
		--Set @Sum03 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo00)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo00))) end as '+@Mes--',Abs(Sum(s.Saldo03)) as '+@Mes
		Set @Sum03 = ',Case(Sum(s.Saldo03)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo03)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo03))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo03)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo03)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo03)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo03))) end end end as '+@Mes
		Set @T103 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo03)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo03) else 0 end)
			     )) as '+@Mes
		Set @T203 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo03)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo03) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo03) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo03) else 0 end)
			     )) as '+@Mes
		Set @T303 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo03)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo03) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo03) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo03) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo03) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo03) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo03) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo03) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 4)
	Begin	Set @Mes = 'ABR'
		--Set @Sum04 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo04)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo04))) end as '+@Mes--',Abs(Sum(s.Saldo04)) as '+@Mes
		Set @Sum04 = ',Case(Sum(s.Saldo04)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo04)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo04))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo04)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo04)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo04)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo04))) end end end as '+@Mes
		Set @T104 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo04)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo04) else 0 end)
			     )) as '+@Mes
		Set @T204 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo04)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo04) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo04) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo04) else 0 end)
			     )) as '+@Mes
		Set @T304 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo04)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo04) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo04) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo04) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo04) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo04) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo04) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo04) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 5)
	Begin	Set @Mes = 'MAY'
		--Set @Sum05 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo05)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo05))) end as '+@Mes--',Abs(Sum(s.Saldo05)) as '+@Mes
		Set @Sum05 = ',Case(Sum(s.Saldo05)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo05)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo05))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo05)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo05)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo05)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo05))) end end end as '+@Mes
		Set @T105 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo05)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo05) else 0 end)
			     )) as '+@Mes
		Set @T205 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo05)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo05) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo05) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo05) else 0 end)
			     )) as '+@Mes
		Set @T305 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo05)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo05) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo05) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo05) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo05) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo05) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo05) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo05) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 6) 
	Begin	Set @Mes = 'JUN'
		--Set @Sum06 =',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo06)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo06))) end as '+@Mes-- ',Abs(Sum(s.Saldo06)) as '+@Mes
		Set @Sum06 = ',Case(Sum(s.Saldo06)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo06)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo06))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo06)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo06)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo06)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo06))) end end end as '+@Mes
		Set @T106 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo06)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo06) else 0 end)
			     )) as '+@Mes
		Set @T206 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo06)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo06) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo06) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo06) else 0 end)
			     )) as '+@Mes
		Set @T306 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo06)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo06) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo06) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo06) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo06) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo06) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo06) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo06) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 7)
	Begin	Set @Mes = 'JUL'
		--Set @Sum07 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo07)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo07))) end as '+@Mes--',Abs(Sum(s.Saldo07)) as '+@Mes
		Set @Sum07 = ',Case(Sum(s.Saldo07)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo07)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo07))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo07)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo07)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo07)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo07))) end end end as '+@Mes
		Set @T107 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo07)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo07) else 0 end)
			     )) as '+@Mes
		Set @T207 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo07)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo07) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo07) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo07) else 0 end)
			     )) as '+@Mes
		Set @T307 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo07)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo07) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo07) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo07) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo07) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo07) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo07) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo07) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 8)
	Begin	Set @Mes = 'AGO'
		--Set @Sum08 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo08)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo08))) end as '+@Mes--',Abs(Sum(s.Saldo08)) as '+@Mes
		Set @Sum08 = ',Case(Sum(s.Saldo08)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo08)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo08))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo08)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo08)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo08)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo08))) end end end as '+@Mes
		Set @T108 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo08)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo08) else 0 end)
			     )) as '+@Mes
		Set @T208 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo08)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo08) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo08) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo08) else 0 end)
			     )) as '+@Mes
		Set @T308 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo08)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo08) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo08) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo08) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo08) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo08) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo08) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo08) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 9)
	Begin	Set @Mes = 'SEP'
		--Set @Sum09 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo09)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo09))) end as '+@Mes--',Abs(Sum(s.Saldo09)) as '+@Mes
		Set @Sum09 = ',Case(Sum(s.Saldo09)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo09)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo09))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo09)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo09)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo09)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo09))) end end end as '+@Mes
		Set @T109 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo09)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo09) else 0 end)
			     )) as '+@Mes
		Set @T209 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo09)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo09) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo09) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo09) else 0 end)
			     )) as '+@Mes
		Set @T309 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo09)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo09) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo09) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo09) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo09) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo09) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo09) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo09) else 0 end)
			     )) as '+@Mes
	End

	Set @Colum0 = @Colum0 + 'Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,0)+'')'' else Convert(varchar,0) end as '+@Mes+','
	Set @Suma = @Suma + 's.Saldo0'+convert(varchar,@i)+'+'
	Set @ColumT = @ColumT + 'Sum(s.Saldo0'+convert(varchar,@i)+') as '+@Mes+','
	Set @i = @i + 1 	
end
while(@i <= @PrdoFin and @PrdoFin >= 10)
begin
	if(@i = 10)
	Begin	Set @Mes = 'OCT'
		--Set @Sum10 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo10)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo10))) end as '+@Mes-- ',Abs(Sum(s.Saldo10)) as '+@Mes
		Set @Sum10 = ',Case(Sum(s.Saldo10)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo10)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo10))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo10)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo10)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo10)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo10))) end end end as '+@Mes
		Set @T110 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo10)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo10) else 0 end)
			     )) as '+@Mes
		Set @T210 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo10)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo10) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo10) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo10) else 0 end)
			     )) as '+@Mes
		Set @T310 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo10)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo10) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo10) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo10) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo10) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo10) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo10) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo10) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 11)
	Begin	Set @Mes = 'NOV'
		--Set @Sum11 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo11)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo11))) end as '+@Mes--',Abs(Sum(s.Saldo11)) as '+@Mes
		Set @Sum11 = ',Case(Sum(s.Saldo11)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo11)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo11))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo11)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo11)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo11)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo11))) end end end as '+@Mes
		Set @T111 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo11)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo11) else 0 end)
			     )) as '+@Mes
		Set @T211 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo11)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo11) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo11) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo11) else 0 end)
			     )) as '+@Mes
		Set @T311 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo11)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo11) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo11) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo11) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo11) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo11) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo11) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo11) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 12)
	Begin	Set @Mes = 'DIC'
		--Set @Sum12 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo12)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo12))) end as '+@Mes--',Abs(Sum(s.Saldo12)) as '+@Mes
		Set @Sum12 = ',Case(Sum(s.Saldo12)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo12)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo12))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo12)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo12)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo12)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo12))) end end end as '+@Mes
		Set @T112 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo12)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo12) else 0 end)
			     )) as '+@Mes
		Set @T212 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo12)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo12) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo12) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo12) else 0 end)
			     )) as '+@Mes
		Set @T312 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo12)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo12) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo12) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo12) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo12) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo12) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo12) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo12) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 13)
	Begin	Set @Mes = 'AJUSTE'
		--Set @Sum13 =',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo13)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo13))) end as '+@Mes-- ',Abs(Sum(s.Saldo13)) as '+@Mes
		Set @Sum13 = ',Case(Sum(s.Saldo13)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo13)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo13))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo13)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo13)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo13)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo13))) end end end as '+@Mes
		Set @T113 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo13)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo13) else 0 end)
			     )) as '+@Mes
		Set @T213 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo13)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo13) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo13) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo13) else 0 end)
			     )) as '+@Mes
		Set @T313 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo13)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo13) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo13) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo13) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo13) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo13) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo13) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo13) else 0 end)
			     )) as '+@Mes
	End
	if(@i = 14)
	Begin	Set @Mes = 'CIERRE'
		--Set @Sum14 = ',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs(Sum(s.Saldo14)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo14))) end as '+@Mes--',Abs(Sum(s.Saldo14)) as '+@Mes
		Set @Sum14 = ',Case(Sum(s.Saldo14)) when 0 then Convert(varchar,0.00) else Case(r.Cd_Rb) when ''IF01'' then Case(left(Convert(varchar,Sum(s.Saldo14)),1)) when ''-'' then  Convert(varchar,Abs(Sum(s.Saldo14))) else ''(''+Convert(varchar,Abs(Sum(s.Saldo14)))+'')'' end else Case(left(Convert(varchar,Sum(s.Saldo14)),1)) when ''-'' then  ''(''+Convert(varchar,Abs(Sum(s.Saldo14)))+'')'' else Convert(varchar,Abs(Sum(s.Saldo14))) end end end as '+@Mes
		Set @T114 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo14)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo14) else 0 end)
			     )) as '+@Mes
		Set @T214 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo14)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo14) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo14) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo14) else 0 end)
			     )) as '+@Mes
		Set @T314 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then (s.Saldo14)*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then (s.Saldo14) else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then (s.Saldo14) else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then (s.Saldo14) else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then (s.Saldo14) else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then (s.Saldo14) else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then (s.Saldo14) else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then (s.Saldo14) else 0 end)
			     )) as '+@Mes
	End

	Set @Colum0 = @Colum0 + 'Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,0)+'')'' else Convert(varchar,0) end as '+@Mes+','
	Set @Suma = @Suma + 's.Saldo'+convert(varchar,@i)+'+'
	Set @ColumT = @ColumT + 'Sum(s.Saldo'+convert(varchar,@i)+') as '+@Mes+','
	Set @i = @i + 1 
end
Set @Colum0 = left(@Colum0,(len(@Colum0)-1))
Set @Suma = left(@Suma,(len(@Suma)-1))
Set @ColumT = left(@ColumT,(len(@ColumT)-1))
Set @SumaT = 'Sum('+@Suma+')'


Set @TG1 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then ('+@Suma+')*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then Abs('+@Suma+') else 0 end)
			     )) as Total'

Set @TG2 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then ('+@Suma+')*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then ('+@Suma+') else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then ('+@Suma+') else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then ('+@Suma+') else 0 end)
			     )) as Total'

Set @TG3 = ',Convert(varchar,Abs(Sum(Case(r.Cd_Rb) when ''IF01'' then ('+@Suma+')*-1 else 0 end) -
			      		Sum(Case(r.Cd_Rb) when ''EF01'' then ('+@Suma+') else 0 end) -
						Sum(Case(r.Cd_Rb) when ''EF02'' then ('+@Suma+') else 0 end) -
							Sum(Case(r.Cd_Rb) when ''EF03'' then ('+@Suma+') else 0 end) +
								Sum(Case(r.Cd_Rb) when ''IF02'' then ('+@Suma+') else 0 end) +
									Sum(Case(r.Cd_Rb) when ''IF03'' then ('+@Suma+') else 0 end) -
										Sum(Case(r.Cd_Rb) when ''EF04'' then ('+@Suma+') else 0 end) -
											Sum(Case(r.Cd_Rb) when ''EF05'' then ('+@Suma+') else 0 end)
			     )) as Total'


print '-----RESULTADOS------'
print @Colum0
print @Suma
print @SumaT
print '---------------------'


DECLARE @SQl1_1 varchar(8000),@SQl1_2 varchar(8000)
DECLARE @SQl2_1_1 varchar(8000),@SQl2_1_2 varchar(8000)
DECLARE @SQl2_2_1 varchar(8000),@SQl2_2_2 varchar(8000)
DECLARE @SQl2_3_1 varchar(8000),@SQl2_3_2 varchar(8000)
DECLARE @SQl2_4_1 varchar(8000),@SQl2_4_2 varchar(8000)
DECLARE @SQl3 varchar(8000)
DECLARE @SQl4_1 varchar(8000)
DECLARE @SQl4_2 varchar(8000)
DECLARE @SQl5_1 varchar(8000)
DECLARE @SQl5_2 varchar(8000)
DECLARE @SQl6_1 varchar(8000)
DECLARE @SQl6_2 varchar(8000)
DECLARE @SQl6_3 varchar(8000)
DECLARE @SQl6_4 varchar(8000)

Set @SQL1_1='' Set @SQL2_1_1='' Set @SQL2_2_1='' Set @SQL2_3_1='' Set @SQL2_4_1='' Set @SQL3=''
Set @SQL1_2='' Set @SQL2_1_2='' Set @SQL2_2_2='' Set @SQL2_3_2='' Set @SQL2_4_2=''
Set @SQL4_1='' Set @SQL5_1='' Set @SQL6_1=''
Set @SQL4_2='' Set @SQL5_2='' Set @SQL6_2='' Set @SQL6_3='' Set @SQL6_4=''


	/*	
	CONSULTA TOTAL DE CABECERAS 
	*************************************************************************
	*/
Set @SQL1_1 = 
	'
	select 
		0 as Ind,
		Case(r.Cd_Rb) when ''IF01'' then 1 when ''EF01'' then 2 when ''EF02'' then 4 when ''EF03'' then 5 
			      when ''IF02'' then 7 when ''IF03'' then 8 when ''EF04'' then 9 when ''EF05'' then 10 
		End as Pos,
		1 as Cab,
		r.Cd_Rb,Case(left(r.Cd_Rb,2)) when ''IF'' then '''' when ''EF'' then '''' when ''TF'' then '''' end as Codigo,
		Upper(r.Descrip) as Descrip'
		+@Sum00+@Sum01+@Sum02+@Sum03+@Sum04+@Sum05+@Sum06
	
Set @SQL1_2 =
	@Sum07+@Sum08+@Sum09+@Sum10+@Sum11+@Sum12+@Sum13+@Sum14+
		',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs('+@SumaT+'))+'')'' else Convert(varchar,Abs('+@SumaT+')) end as Total
	from SaldosXPrdoN4'+@IndCS+@Mda+' s	
	left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
	left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
	where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD4+@RangoH4+'
	Group by r.Cd_Rb,r.Descrip Having isnull(r.Cd_Rb,''0'') <> ''0''
	'

	/*	
	CONSULTA DETALLE X CUENTAS DEL NIVEL 1,2,3,4
	*************************************************************************
	*/
if(@n1 = 1)
Begin
	Set @SQL2_1_1 = 
		'
		UNION ALL

		select 
			1 as Ind,
			Case(r.Cd_Rb) when ''IF01'' then 1 when ''EF01'' then 2 when ''EF02'' then 4 when ''EF03'' then 5 
				      when ''IF02'' then 7 when ''IF03'' then 8 when ''EF04'' then 9 when ''EF05'' then 10 
			End as Pos,
			2 as Cab,
			s.NroCtaN1,
			s.NroCtaN1 as Codigo,p.NomCta'
			+@Sum00+@Sum01+@Sum02+@Sum03+@Sum04+@Sum05+@Sum06
	Set @SQL2_1_2 = 
		@Sum07+@Sum08+@Sum09+@Sum10+@Sum11+@Sum12+@Sum13+@Sum14+
			',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs('+@SumaT+'))+'')'' else Convert(varchar,Abs('+@SumaT+')) end as Total
		from SaldosXPrdoN1'+@IndCS+@Mda+' s	
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN1 and p.Ejer=s.Ejer
		left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF 
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD1+@RangoH1+'
		Group by r.Cd_Rb,s.NroCtaN1,p.NomCta Having isnull(r.Cd_Rb,''0'') <> ''0''
		'
End

if(@n2 = 1)
Begin
	Set @SQL2_2_1 =
		'

		UNION ALL

		select 
			2 as Ind,
			Case(r.Cd_Rb) when ''IF01'' then 1 when ''EF01'' then 2 when ''EF02'' then 4 when ''EF03'' then 5 
				      when ''IF02'' then 7 when ''IF03'' then 8 when ''EF04'' then 9 when ''EF05'' then 10 
			End as Pos,
			2 as Cab,
			s.NroCtaN2,
			s.NroCtaN2 as Codigo,p.NomCta'
			+@Sum00+@Sum01+@Sum02+@Sum03+@Sum04+@Sum05+@Sum06
	Set @SQL2_2_2 =
		@Sum07+@Sum08+@Sum09+@Sum10+@Sum11+@Sum12+@Sum13+@Sum14+
			',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs('+@SumaT+'))+'')'' else Convert(varchar,Abs('+@SumaT+')) end as Total
		from SaldosXPrdoN2'+@IndCS+@Mda+' s	
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN2 and p.Ejer=s.Ejer
		left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD2+@RangoH2+'
		Group by r.Cd_Rb,s.NroCtaN2,p.NomCta Having isnull(r.Cd_Rb,''0'') <> ''0''
		'
End

if(@n3 = 1)
Begin
	Set @SQL2_3_1 =
		'

		UNION ALL

		select 
			3 as Ind,
			Case(r.Cd_Rb) when ''IF01'' then 1 when ''EF01'' then 2 when ''EF02'' then 4 when ''EF03'' then 5 
				      when ''IF02'' then 7 when ''IF03'' then 8 when ''EF04'' then 9 when ''EF05'' then 10 
			End as Pos,
			2 as Cab,
			s.NroCtaN3,
			s.NroCtaN3 as Codigo,p.NomCta'
			+@Sum00+@Sum01+@Sum02+@Sum03+@Sum04+@Sum05+@Sum06
	Set @SQL2_3_2 =
		@Sum07+@Sum08+@Sum09+@Sum10+@Sum11+@Sum12+@Sum13+@Sum14+
			',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs('+@SumaT+'))+'')'' else Convert(varchar,Abs('+@SumaT+')) end as Total
		from SaldosXPrdoN3'+@IndCS+@Mda+' s	
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN3 and p.Ejer=s.Ejer
		left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD3+@RangoH3+'
		Group by r.Cd_Rb,s.NroCtaN3,p.NomCta Having isnull(r.Cd_Rb,''0'') <> ''0''
		'
End

if(@n4 = 1)
Begin
	Set @SQL2_4_1 =
		'
		
		UNION ALL

		select 
			4 as Ind,
			Case(r.Cd_Rb) when ''IF01'' then 1 when ''EF01'' then 2 when ''EF02'' then 4 when ''EF03'' then 5 
				      when ''IF02'' then 7 when ''IF03'' then 8 when ''EF04'' then 9 when ''EF05'' then 10 
			End as Pos,
			2 as Cab,
			s.NroCtaN4,
			s.NroCtaN4 as Codigo,p.NomCta'
			+@Sum00+@Sum01+@Sum02+@Sum03+@Sum04+@Sum05+@Sum06
	Set @SQL2_4_2 =
		@Sum07+@Sum08+@Sum09+@Sum10+@Sum11+@Sum12+@Sum13+@Sum14+
			',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,Abs('+@SumaT+'))+'')'' else Convert(varchar,Abs('+@SumaT+')) end as Total
		from SaldosXPrdoN4'+@IndCS+@Mda+' s	
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD4+@RangoH4+'
		Group by r.Cd_Rb,s.NroCtaN4,p.NomCta Having isnull(r.Cd_Rb,''0'') <> ''0''
		'
End

	/*	
	CONSULTA CABECERAS SIN TOTALES
	*/
Set @SQL3 = 
	'

	UNION ALL

	select 
		0 as Ind,
		Case(r.Cd_Rb) when ''IF01'' then 1 when ''EF01'' then 2 when ''EF02'' then 4 when ''EF03'' then 5 
			      when ''IF02'' then 7 when ''IF03'' then 8 when ''EF04'' then 9 when ''EF05'' then 10 
		End as Pos,
		1 as Cab,
		r.Cd_Rb,Case(left(r.Cd_Rb,2)) when ''IF'' then '''' when ''EF'' then '''' when ''TF'' then '''' end as Codigo,
		Upper(r.Descrip),'
		+@Colum0+
		',Case(left(r.Cd_Rb,2)) when ''EF'' then ''(''+Convert(varchar,0)+'')'' else Convert(varchar,0) end as Total
	from RubrosRpt r
	where r.Cd_TR=''02'' and r.Cd_Rb not in (select p.Cd_EGPF from PlanCtas p where RucE='''+@RucE+''' and isnull(len(p.Cd_EGPF),0)<>0 Group by p.Cd_EGPF Having isnull(r.Cd_Rb,''0'') <> ''0'')
	'

	/*	
	CONSULTA PRIMER TOTAL CON FORMULA (IF01 - EF01)
	*/
Set @SQL4_1 = 
	'

	UNION ALL	

	select  
		-1 as Ind,
		3 as Pos,
		1 as Cab,
		''T100'' as Cd_Rb, '''' as Codigo, Upper(''Utilidad Bruta'') as Descrip'
		+@T100+@T101+@T102+@T103+@T104+@T105+@T106+@T107
Set @SQL4_2 = 
	+@T108+@T109+@T110+@T111+@T112+@T113+@T114+
		@TG1+
	'
	from SaldosXPrdoN4'+@IndCS+@Mda+' s	
	left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
	left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
	where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD4+@RangoH4+'
	'



	/*	
	CONSULTA PRIMER TOTAL CON FORMULA (IF01 - EF01 - EF02 - EF03)
	*/

Set @SQL5_1 = 
	'

	UNION ALL	

	select 
		-1 as Ind,
		6 as Pos,
		1 as Cab,
		''T200'' as Cd_Rb, '''' as Codigo, Upper(''Utilidad (Perdida) Operativa'') as Descrip'
		+@T200+@T201+@T202+@T203+@T204+@T205+@T206+@T207
Set @SQL5_2 = 
	@T208+@T209+@T210+@T211+@T212+@T213+@T214+
		@TG2+
	'
	from SaldosXPrdoN4'+@IndCS+@Mda+' s	
	left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
	left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
	where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD4+@RangoH4+'
	'



	/*	
	CONSULTA PRIMER TOTAL CON FORMULA (IF01 - EF01 - EF02 - EF03 + IF02 + IF03 - EF04 - EF05)
	*/
Set @SQL6_1 = 
	'
	
	UNION ALL

	select  
		-1 as Ind,
		11 as Pos,
		1 as Cab,
		''T300'' as Cd_Rb, '''' as Codigo, Upper(''Resultado Antes de Impuesto'') as Descrip'
		+@T300+@T301+@T302+@T303+@T304
Set @SQL6_2 = 
	@T305+@T306+@T307+@T308+@T309+@T310

Set @SQL6_3 =
	@T311+@T312+@T313+@T314
Set @SQL6_4 =
	@TG3+
	'
	from SaldosXPrdoN4'+@IndCS+@Mda+' s	
	left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
	left join RubrosRpt r on r.Cd_Rb=p.Cd_EGPF
	where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and isnull(len(p.Cd_EGPF),0)<>0'+@RangoCC+@RangoD4+@RangoH4+'
	'




PRINT @SQL1_1
PRINT @SQL1_2
PRINT @SQL2_1_1
PRINT @SQL2_1_2
PRINT @SQL2_2_1
PRINT @SQL2_2_2
PRINT @SQL2_3_1
PRINT @SQL2_3_2
PRINT @SQL2_4_1
PRINT @SQL2_4_2
PRINT @SQL3
PRINT @SQL4_1
PRINT @SQL4_2
PRINT @SQL5_1
PRINT @SQL5_2
PRINT @SQL6_1
PRINT @SQl6_2
PRINT @SQl6_3
PRINT @SQl6_4

EXEC ('('+@SQL1_1+@SQL1_2+@SQL2_1_1+@SQL2_1_2+@SQL2_2_1+@SQL2_2_2+@SQL2_3_1+@SQL2_3_2+@SQL2_4_1+@SQL2_4_2+@SQL3+@SQL4_1+@SQL4_2+@SQL5_1+@SQL5_2+@SQL6_1+@SQl6_2+@SQl6_3+@SQl6_4+') Order by 2,3,4')

-- DI->(25/11/2009) : Copia del procedimiento anterior y Modificacion del CC,SC,SS
GO
