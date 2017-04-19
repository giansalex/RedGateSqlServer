SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec [user321].[Rpt_Voucher_DAOT] '20504743561','2010',null
----20504743561
CREATE procedure [user321].[Rpt_Voucher_DAOT]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

declare @UIT int
set @UIT=3600--(select UIT from UIT where Ejer=@Ejer)


	if not exists(select top 1 *from voucher Where RucE=@RucE and Ejer=@Ejer)
		set @msj='No tiene Movimientos de Voucher'
	else
	begin
	-- GMC 20504743561
		--detalle DAOT
		select 	Max(p.NDoc) NDoc, case(isnull(Max(p.RSocial),'')) when '' then isnull(Max(p.ApPat),'')+' '+isnull(Max(p.ApMat),'')+', '+isnull(Max(p.Nom),'') else isnull(Max(p.RSocial),'') end as 'RSocial',
			Max(v.Cd_Prv) Cd_Prv,v.RegCtb, Convert(nvarchar,v.FecMov,103) FecMov,
			Max(v.Cd_TD) Cd_TD,Max(v.NroSre) NroSre ,Max(v.NroDoc) NroDoc,Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) +
			Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+ Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) +
			Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end) as SumBase
		from 	Voucher v left join Proveedor2 p on p.RucE=v.RucE and p.Cd_Prv=v.Cd_Prv
		where 	v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='RC'
		group by v.RegCtb,v.FecMov/*,v.Cd_TD,v.NroSre,v.NroDoc*/
		Having	Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+
			Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end)>2*@UIT
		order by Max(v.Cd_Prv),v.RegCtb

		--ESTA OBLIGADO A DECLARAR?
		declare @rpta varchar(50)
		set @rpta=''
	
			set @rpta =(select  'Se tiene que declarar DAOT' as Declarar
			            from Voucher v where RucE=@RucE and Ejer=@Ejer and v.Cd_Fte='RC'
				    Having Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+
		  	   	    Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end)>75*@UIT)
			if(@rpta='' or @rpta is null)
			set @rpta =(select  'Se tiene que declarar DAOT' as Declarar from Voucher v where RucE=@RucE and Ejer=@Ejer and v.Cd_Fte='RV'
				    Having Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end)+
 		                    Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) + Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end)>75*@UIT)
			
		select @rpta Respuesta, @RucE Ruc, RSocial from Empresa Where Ruc=@RucE
	end
-- Leyenda --
--JJ 23/02/2011 : <Creacion del Procedimiento Almacenado>


GO
