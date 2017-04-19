SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherConsNDxRC]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@msj varchar(100) output
as

if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	Set @msj = 'No existe voucher con el registro contable '+@RegCtb

else
begin
	select top 1 /*convert(char(10),FecED,103) as*/ FecED,
	Cd_TD,
	NroSre,
	NroDoc	
	from Voucher
	where RucE=@RucE and RegCtb=@RegCtb and NroDoc is not null
end

print @msj

/*
J -> CREADO 23/09/2009 DOCUMENTO DE REFERENCIA
PV: LUN 05/10/2009 Mdf: retornaba nro docs null
*/


GO
