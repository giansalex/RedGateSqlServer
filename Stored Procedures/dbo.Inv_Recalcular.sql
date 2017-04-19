SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Recalcular]  
@RucE nvarchar(11),
@CadenaCd_Prod varchar(4000),
@FecMov datetime = null,
@MovInvCtb bit = null output,  
@msj varchar(100) output  

as

declare @IB_KardexAlm bit
declare @IB_KardexUM bit

select 
	@IB_KardexAlm = IB_KardexAlm, 
	@IB_KardexUM = IB_KardexUM,
	@MovInvCtb = IB_MovInvCtbLin 
from CfgGeneral where RucE = @RucE  

if @IB_KardexAlm is null
	set @IB_KardexAlm =  0
if @IB_KardexUM is null
	set @IB_KardexUM =  0
if @MovInvCtb is null
	set @MovInvCtb =  0

declare @ID_UMP int 
declare @Cd_Alm varchar(20) 

while(len(@CadenaCd_Prod) >0)  
begin

	if @FecMov is null
		set @FecMov = (select min(FecMov) from inventario where RucE = @RucE and Cd_Prod = left(@CadenaCd_Prod, 7))
		
	if(@IB_KardexAlm = 1)
	begin
		if(@IB_KardexUM = 1)
		begin
			declare Cur_UMPAlm cursor for select ID_UMP, Cd_Alm from Inventario where RucE = @RucE and Cd_Prod =left(@CadenaCd_Prod, 7) and FecMov>=@FecMov group by ID_UMP, Cd_Alm order by ID_UMP, Cd_Alm
			open Cur_UMPAlm
				fetch Cur_UMPAlm into @ID_UMP, @Cd_Alm
					while(@@fetch_status = 0)
					begin
						exec Inv_RecalcularUn @RucE, @CadenaCd_Prod, @ID_UMP, @Cd_Alm, @FecMov,@msj out
						--print @Cd_Alm + ' ' + convert(varchar, @ID_UMP) + ' ' + left(@CadenaCd_Prod, 7)
						fetch Cur_UMPAlm into @ID_UMP, @Cd_Alm
					end
			close Cur_UMPAlm
			deallocate Cur_UMPAlm
		end
		else
		begin
			declare Cur_Alm cursor for select Cd_Alm from Inventario where RucE = @RucE and Cd_Prod =left(@CadenaCd_Prod, 7) and FecMov>=@FecMov group by Cd_Alm order by Cd_Alm
			open Cur_Alm
				fetch Cur_Alm into @Cd_Alm
					while(@@fetch_status = 0)
					begin
						exec Inv_RecalcularUn @RucE, @CadenaCd_Prod, null,  @Cd_Alm, @FecMov,@msj out
						--print @Cd_Alm + ' ' + left(@CadenaCd_Prod, 7)
						fetch Cur_Alm into @Cd_Alm
					end
			close Cur_Alm
			deallocate Cur_Alm
		end
	end
	else
	begin
		if(@IB_KardexUM = 1)
		begin	
			declare Cur_UMP cursor for select ID_UMP from Inventario where RucE = @RucE and Cd_Prod =left(@CadenaCd_Prod, 7) and FecMov>=@FecMov group by ID_UMP order by ID_UMP
			open Cur_UMP
				fetch Cur_UMP into @ID_UMP
					while(@@fetch_status = 0)
					begin
						exec Inv_RecalcularUn @RucE, @CadenaCd_Prod, @ID_UMP, null, @FecMov,@msj out
						--print convert(varchar, @ID_UMP) + ' ' + left(@CadenaCd_Prod, 7)
						fetch Cur_UMP into @ID_UMP
					end
			close Cur_UMP
			deallocate Cur_UMP
		end
		else
		begin
			exec Inv_RecalcularUn @RucE, @CadenaCd_Prod, null, null, @FecMov,@msj out  
		end
	end
	set @CadenaCd_Prod = right(@CadenaCd_Prod, len(@CadenaCd_Prod)-7)  
end  
  
-- Leyenda --  
-- PP : 2010-08-10 12:16:04.843 : <Creacion del procedimiento almacenado>  

--select Cd_Alm from Inventario where RucE = '11111111111' and Cd_Prod =left('PD00001', 7) and FecMov>=isnull(null, (select min(FecMov) from inventario where RucE = '11111111111' and Cd_Prod = left('PD00001', 7))) group by Cd_Alm
  
GO
