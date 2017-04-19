SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaMdf]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@FecMov smalldatetime,
@FecCbr smalldatetime,
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@Cd_Sr nvarchar(4),
@FecED smalldatetime,
@FecVD smalldatetime,
@Cd_Cte nvarchar(7),
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
@BIM numeric(13,2),
@INF numeric(13,2),
@EXO numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
--@FecReg datetime,
--@FecMdf datetime,
--@UsuCrea nvarchar(10),
@UsuModf nvarchar(10),
@IB_Anulado bit,
@msj varchar(100) output
as
if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin
	update Venta set FecMov=@FecMov, FecCbr=@FecCbr, Cd_TD=@Cd_TD, NroDoc=@NroDoc,
			 Cd_Sr=@Cd_Sr, FecED=@FecED, FecVD=@FecVD, Cd_Cte=@Cd_Cte, Cd_Vdr=@Cd_Vdr,
			 Cd_Area=@Cd_Area, Cd_MR=@Cd_MR, Obs=@Obs, BIM=@BIM, INF=@INF, EXO=@EXO, IGV=@IGV, Total=@Total,
			 Cd_Mda=@Cd_Mda, CamMda=@CamMda, FecMdf=getdate(), UsuModf=@UsuModf, IB_Anulado=@IB_Anulado
	where RucE=@RucE and Cd_Vta=@Cd_Vta

	if @@rowcount <= 0
	begin
	   set @msj = 'Venta no pudo ser modificado'
	   return
	end

		
	  
	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'02')
	-----------------------------------------------------------------------------------
end
print @msj
--DG
GO
