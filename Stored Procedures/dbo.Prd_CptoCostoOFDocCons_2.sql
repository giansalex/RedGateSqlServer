SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_CptoCostoOFDocCons_2]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
@msj varchar(100) output
as
declare 
@count2 varchar(1000),
@cond2 varchar(1000),
@rest2 varchar(100),
@selRgctb varchar(100)
set @selRgctb = (select regctb from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF)
set @count2 = (select count(RegCtb) from CptoCostoOFDoc where RucE=@RucE and regctb=(select regctb from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF) )
set @cond2 = (select count(v.RegCtb) from voucher v inner join planctas cta on cta.RucE=v.ruce and v.nrocta=cta.nrocta where v.RucE=@RucE and v.regCtb=@selRgctb  and cta.IB_Imp=1)
set @rest2 = case when @count2=0 then 1 else @count2 end

if not exists (select * from CptoCostoOFDoc where Cd_OF=@Cd_OF and RucE = @RucE and Id_CCOF=@Id_CCOF)
	set @msj = 'Documento relacionado a Concepto de Costo no existe'
else	
	select c.*,
	case when @cond2 >1
	then 
		(case (v.Cd_MdOr) when '02' then (SUM((v.MtoD_ME-v.MtoH_ME)))/@rest2 else  (sum(v.MtoD-v.MtoH))/@rest2 end )
		-
		(select SUM(cstAsig) from CptoCostoOFDoc where regctb = @selRgctb)
		+
		(select SUM(CstAsig)from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF )
	else	
		((case (v.Cd_MdOr) when '02' then SUM((v.MtoD_ME-v.MtoH_ME)) else  sum(v.MtoD-v.MtoH) end) / COUNT(v.RegCtb))
		-
		(select SUM(cstAsig) from CptoCostoOFDoc where regctb= @selRgctb)
		+ 
		(select SUM(CstAsig)from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF)	end as Costo
		
	from CptoCostoOFDoc c 
	inner join voucher as v on c.Ruce = v.RucE and c.RegCtb = v.RegCtb and c.NroCta=v.NroCta
	where c.Id_CCOF=@Id_CCOF and c.Cd_OF=@Cd_OF and c.RucE = @RucE --and (c.regCtb + '|' + c.nrocta) in (''+@RctbNcta+'')
	
	group by c.RucE, c.Cd_OF, c.Id_CCOF, c.RegCtb,c.NroCta,c.CstAsig,c.Cd_Mda,c.CamMda,v.Cd_MdOr
	order by c.Cd_OF
print @msj

--exec Prd_CptoCostoOFDocCons_2 '11111111111','OF00000099','1',null

----select * from voucher where RucE= '20543954773'  and ejer='2012' and Prdo = '03'
GO
