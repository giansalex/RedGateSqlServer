SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoConsxMIS] --<Procedimiento que consulta los asientosxMtvoIngSal>
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_MIS char(3),
@TipCons int,
@msj varchar(100) output
as
begin

	--Consulta general--
	if(@TipCons=0)
	begin
		select a.RucE,a.Cd_MIS,mtv.Descrip as DescripMTV,a.Item,a.Cta,cta.NomCta,a.IC_CaAb,a.Cd_IV,iv.Descrip as DescripIV,isnull(convert(nvarchar,a.Porc),a.FmlaUsu) as PorcFmla,a.GlosaUsu,a.Cd_CC,a.Cd_SC,a.Cd_SS,a.IB_Aux
		from Asiento a
		Left join MtvoIngSal mtv on mtv.RucE=a.RucE and mtv.Cd_MIS=a.Cd_MIS
		Left join IndicadorValor iv on iv.Cd_IV=a.Cd_IV
		Left join PlanCtas cta on cta.RucE = a.RucE and cta.NroCta = a.Cta and cta.Ejer=@Ejer
		Where a.RucE=@RucE and a.Cd_MIS=@Cd_MIS and a.Ejer=@Ejer
	end

end
print @msj
------------
--J : 20-04-2010 - <Creacion del procedimiento almacenado>
--FL : 05-08-2010 - <Modificacion del procedimiento almacenado para mostrar mas campos>
--MM 19-11-2010 - <Modificacion del procedimiento almacenado por agregacion de campos>
--FL : 27-01-2011 <se agrego ejercicio para plan de cuentas y para asiento para que solo carguen los asientos correspondientes al ejercicio>



GO
