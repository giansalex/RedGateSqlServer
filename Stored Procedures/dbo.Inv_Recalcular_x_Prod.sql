SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Recalcular_x_Prod]
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecMov datetime = null,
@msj varchar(100) output
 as
declare @FecMovInt datetime
declare @Cd_Inv char(12)
declare @Cd_InvAnt char(12)
declare @IC_ES char(1)
declare @Cant numeric(13,3)
declare @Total numeric(15,4)
declare @Total_ME numeric(15,4)
declare @SCant numeric(13,3)
declare @CProm numeric(15,4)
declare @SCT numeric(15,4)
declare @CProm_ME numeric(15,4)
declare @SCT_ME numeric(15,4)
declare @TipNC char(2)
declare @CamMda numeric(6,3)

if(@FecMov is null)
	select @FecMov = min(FecMov) from inventario where RucE = @RucE and Cd_Prod = @Cd_Prod
select top 1 @Cd_InvAnt = Cd_Inv from Inventario where RucE = @RucE and FecMov<@FecMov and Cd_Prod = @Cd_Prod order by FecMov  desc, Cd_Inv desc
declare Cur_Inv cursor for select Cd_Inv from Inventario where RucE = @RucE and Cd_Prod =@Cd_Prod and FecMov>=@FecMov order by FecMov,Cd_Inv
open Cur_Inv
	fetch Cur_Inv into @Cd_Inv
		while(@@fetch_status = 0)
		begin
			select @IC_ES = IC_ES, @TipNC = TipNC from Inventario where RucE = @RucE and Cd_Inv = @Cd_Inv
			if(@IC_ES = 'S')			
			begin
				select @CProm = CProm, @CProm_ME = CProm_ME from Inventario where RucE = @RucE and Cd_Inv = @Cd_InvAnt
				if(@TipNC is null)
					update Inventario set Total = Cant * isnull(@CProm,0), CosUnt = isnull(@CProm,0), Total_ME = Cant * isnull(@CProm_ME,0), CosUnt_ME = isnull(@CProm_ME,0) where RucE = @RucE and Cd_Inv = @Cd_Inv
			end			
			select @Cant = Cant, @Total = Total, @Total_ME = Total_ME, @FecMovInt = FecMov from Inventario where RucE = @RucE and Cd_Inv = @Cd_Inv
			if(@TipNC ='DS')
				select top 1 @SCant = SCant, @SCT = SCT+ isnull(@Total,0), @SCT_ME = SCT_ME+ isnull(@Total_ME,0) from Inventario where RucE = @RucE and Cd_Inv = @Cd_InvAnt order by FecMov  desc, Cd_Inv desc
			else
				select top 1 @SCant = isnull(SCant,0) + isnull(@Cant,0), @SCT = isnull(SCT,0)+ isnull(@Total,0), @SCT_ME = isnull(SCT_ME,0)+ isnull(@Total_ME,0) from Inventario where RucE = @RucE and Cd_Inv = @Cd_InvAnt order by FecMov  desc, Cd_Inv desc
			set @SCant =  isnull(@SCant,isnull(@Cant,0))
			set @SCT = isnull(@SCT,isnull(@Total,0))
			set @SCT_ME = isnull(@SCT_ME,isnull(@Total_ME,0))
			--si pablo no kiere  saldo negativo  se tieen k  hacer if(@SCant <0) set @SCant = 0
			if(@SCant <>0)
			begin
				set @CProm = @SCT/@SCant
				set @CProm_ME = @SCT_ME/@SCant
			end
			else 
			begin
				set @CProm = 0
				set @SCT = 0
				set @CProm_ME = 0
				set @SCT_ME = 0
			end
			update Inventario set Scant = @Scant, SCT = @SCT , CProm = @CProm, SCT_ME = @SCT_ME , CProm_ME = @CProm_ME where RucE = @RucE and Cd_Inv = @Cd_Inv
			if(@IC_ES = 'S')
				update Inventario set CamMda = case(CosUnt_ME) when 0 then 1 else CosUnt/CosUnt_ME end where RucE = @RucE and Cd_Inv = @Cd_Inv
			set @Cd_InvAnt = @Cd_Inv
			fetch Cur_Inv into @Cd_Inv
		end
close Cur_Inv
deallocate Cur_Inv


-- Leyenda --
-- PP : 2010-08-09 17:56:31.843	: <Creacion del procedimiento almacenado>
-- PP : 03/07/2011 :  Modificacion para   moneda  extrangera 
GO
