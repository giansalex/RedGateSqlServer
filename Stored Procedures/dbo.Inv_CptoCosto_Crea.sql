SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Inv_CptoCosto_Crea]
@RucE nvarchar(11),
@CodSNT_ varchar(4),
@Descrip varchar(200),
@NCorto varchar(5),
@Estado bit,
@IB_Prin bit, 
@msj varchar(100) output
as

if exists (select * from CptoCosto where RucE = @RucE and CodSNT_ = @CodSNT_)
	begin
		set @msj = 'Ya existe Concepto de Costo'
		return
	end
else 
begin
	if (@IB_Prin = 1)
		begin 
		 update CptoCosto set IB_Prin = 0 where RucE = @RucE 
		end
			
	insert into CptoCosto(RucE, Cd_Cos,CodSNT_, Descrip, NCorto, Estado,IB_Prin) 
	values (@RucE, dbo.CdCptoCosto(@RucE), @CodSNT_, @Descrip, @NCorto, @Estado,@IB_Prin)
	if (@@rowcount <= 0)
	set @msj = 'No puede ser ingresada'
end
print @msj

--bg: 12/03/2013 <se altero el sp agregando IB_Prin>
--bg: 12/03/2013 <se agrego la condicion de IB_Prin>
GO
