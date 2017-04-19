SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Ctb_VoucherConsUn_Info]
@RucE nvarchar(11),
@RegCtb nvarchar (15),
@Ejer nvarchar (4),
@msj varchar(100) output
as
declare @var varchar(5) = (select Cd_Cos from CptoCosto where ruce=@RucE and IB_Prin=1)
declare @var2 varchar(100) = (select Descrip from CptoCosto where ruce=@RucE and IB_Prin=1)
if not exists (select RegCtb from Voucher where RucE = @RucE and Ejer = @Ejer)
	set @msj = 'Voucher no existe'
	else	
		select v.RucE, v.Ejer,v.Prdo , v.RegCtb, max(v.Cd_TD) as Cd_TD, max(v.NroSre) as NroSre, max(v.NroDoc) as NroDoc, v.Cd_MdOr ,v.CamMda, @var as Cd_Cos, @var2 as NomGasto --pc.NroCta 
    from Voucher  v
        --inner join planctas pc on pc.ruce=v.ruce and pc.NroCta = v.NroCta
    where v.RucE = @RucE and v.regctb=@RegCtb and v.ejer= @Ejer --and v.NroCta='94.2.1.10'    
    group by v.RucE, v.Ejer,v.Prdo, v.RegCtb, v.Cd_MdOr,v.CamMda--,pc.NroCta
	
print @msj

--Leyenda
--BG : 08/02/2013 <se creo el SP--/(.)(.)\>

--exec Ctb_VoucherConsUn_Info '11111111111','CPGE_RC02-00002','2013',''
 

GO
