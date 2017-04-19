SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ValidarImpNN]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	Set @msj = 'No existe voucher con el registro contable '+@RegCtb
else
begin
	select top 1 
		Convert(char(10),FecMov,103) as FecMov,
		MtoD,MtoH,MtoD_ME,MtoH_ME,
		case(Cd_MdRg) when '01' then (MtoD+MtoH) else (MtoD_ME+MtoH_ME) end  as Importe,
		NroChke,
		Grdo
	from Voucher 
	where RucE=@RucE and RegCtb=@RegCtb and (left(NroCta,2)='10' or left(NroCta,2)='12')
end
print @msj


GO
