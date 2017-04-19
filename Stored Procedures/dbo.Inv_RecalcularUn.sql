SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_RecalcularUn]
@RucE nvarchar(11),
@Cd_Prod char(7),
@ID_UMP int, 
@Cd_Alm varchar(20),
@FecMov datetime,
@msj varchar(100) output
 as
declare @Ejer char(4) 
declare @RegCtb char(15)
declare @FecMovInt datetime
declare @Cd_Inv char(12)
declare @Cd_InvAnt char(12)
declare @IC_ES char(1)
declare @Cant numeric(13,3)
declare @Total numeric(15,7)
declare @Total_ME numeric(15,7)
declare @CosUnt numeric(15,7)
declare @CosUnt_ME numeric(15,7)
declare @SCant numeric(13,3)
declare @CProm numeric(15,7)
declare @SCT numeric(15,7)
declare @CProm_ME numeric(15,7)
declare @SCT_ME numeric(15,7)
declare @TipNC char(2)

if(@FecMov is null)
	select @FecMov = min(FecMov) from inventario where RucE = @RucE and Cd_Prod = @Cd_Prod

if(@Cd_Alm is null)
begin
	if(@ID_UMP is null)
	begin	
		select top 1 @Cd_InvAnt = Cd_Inv from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov<@FecMov order by FecMov  desc, Cd_Inv desc
		declare Cur_Inv cursor for select Cd_Inv from Inventario where RucE = @RucE and Cd_Prod =@Cd_Prod and FecMov>=@FecMov order by FecMov,Cd_Inv
	end
	else
	begin
		select top 1 @Cd_InvAnt = Cd_Inv from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov<@FecMov and ID_UMP = @ID_UMP order by FecMov  desc, Cd_Inv desc
		declare Cur_Inv cursor for select Cd_Inv from Inventario where RucE = @RucE and Cd_Prod =@Cd_Prod and FecMov>=@FecMov and ID_UMP = @ID_UMP order by FecMov,Cd_Inv
	end		
end
else
begin
	if(@ID_UMP is null)
	begin
	print @Cd_Alm
		select top 1 @Cd_InvAnt = Cd_Inv from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov<@FecMov and Cd_Alm = @Cd_Alm order by FecMov  desc, Cd_Inv desc
		declare Cur_Inv cursor for select Cd_Inv from Inventario where RucE = @RucE and Cd_Prod =@Cd_Prod and FecMov>=@FecMov and Cd_Alm = @Cd_Alm order by FecMov,Cd_Inv	
	end
	else
	begin
		select top 1 @Cd_InvAnt = Cd_Inv from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov<@FecMov and ID_UMP = @ID_UMP and Cd_Alm = @Cd_Alm order by FecMov  desc, Cd_Inv desc
		declare Cur_Inv cursor for select Cd_Inv from Inventario where RucE = @RucE and Cd_Prod =@Cd_Prod and FecMov>=@FecMov and ID_UMP = @ID_UMP and Cd_Alm = @Cd_Alm order by FecMov,Cd_Inv
	end
end

--select top 1 @Cd_InvAnt = Cd_Inv from Inventario where RucE = @RucE and FecMov<@FecMov and Cd_Prod = @Cd_Prod order by FecMov  desc, Cd_Inv desc
--declare Cur_Inv cursor for select Cd_Inv from Inventario where RucE = @RucE and Cd_Prod =@Cd_Prod and FecMov>=@FecMov order by FecMov,Cd_Inv

open Cur_Inv
	fetch Cur_Inv into @Cd_Inv
		while(@@fetch_status = 0)
		begin
		print @Cd_Inv
			select @IC_ES = IC_ES, @TipNC = TipNC from Inventario where RucE = @RucE and Cd_Inv = @Cd_Inv
			if(@IC_ES = 'S')			
			begin
				select @CProm = CProm, @CProm_ME = CProm_ME from Inventario where RucE = @RucE and Cd_Inv = @Cd_InvAnt
				if(@TipNC is null)
					update Inventario set Total = Cant * isnull(@CProm,0), CosUnt = isnull(@CProm,0), Total_ME = Cant * isnull(@CProm_ME,0), CosUnt_ME = isnull(@CProm_ME,0) where RucE = @RucE and Cd_Inv = @Cd_Inv
			end
			else
			begin
				select @RegCtb = RegCtb, @Ejer = Ejer from Inventario where RucE = @RucE and Cd_Inv = @Cd_Inv
				if(@ID_UMP is null)
					select @ID_UMP = ID_UMP from Inventario where RucE = @RucE and Cd_Inv = @Cd_Inv 
			
				declare @Cd_Mda char(2)
				select @Cd_Mda = Cd_Mda from Inventario where RucE = @RucE and  Cd_Prod = @Cd_Prod and  RegCtb = @RegCtb
				
				--TODO REVISAR!
				if(@Cd_Mda = '01')
					update Inventario set Total_ME = Total/CamMda, CosUnt_ME = CosUnt/CamMda where RucE = @RucE and  Cd_Prod = @Cd_Prod and  RegCtb = @RegCtb
				else
					update Inventario set Total = Total_ME*CamMda, CosUnt = CosUnt_ME*CamMda where RucE = @RucE and  Cd_Prod = @Cd_Prod and  RegCtb = @RegCtb
				
				declare @EntCant int
				declare @SalCant int				
				select @EntCant = count(*) from Inventario where RucE = @RucE and Ejer = @Ejer and RegCtb = @RegCtb and IC_ES = 'E'
				select @SalCant = count(*) from Inventario where RucE = @RucE and Ejer = @Ejer and RegCtb = @RegCtb and IC_ES = 'S'				
				if(select min(Cd_TDES) from Inventario where RucE = @RucE and RegCtb = @RegCtb and Cd_TDES is not null) = 'OF' -- Es Frabricacion
				begin
					if(@EntCant != 1) -- por el momento primera parte de OF
					begin
						if exists (select * from Inventario where RucE = @RucE and RegCtb = @RegCtb and Cd_TO = '11' and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and IC_ES= 'S' and CosUnt <> 0 and CosUnt_ME <> 0)
						begin
							select @CosUnt = CosUnt, @CosUnt_ME = CosUnt_ME from Inventario where RucE = @RucE and RegCtb = @RegCtb and Cd_Prod = @Cd_Prod and IC_ES= 'S' and ID_UMP = @ID_UMP
							update Inventario set CosUnt = @CosUnt,CosUnt_ME = @CosUnt_ME, Total = Cant * @CosUnt, Total_ME = Cant * @CosUnt_ME where RucE = @RucE and Cd_Inv = @Cd_Inv
						end 
					end 
					else -- por el momento segunda parte de OF
					begin
						select @Total = -sum(Total), @Total_ME = -sum(Total_ME) from Inventario where RucE = @RucE and RegCtb = @RegCtb and IC_ES= 'S' 
						declare @Cd_OF char(10)
						select @Cd_OF = max(Cd_OF) from Inventario where Ruce = @RucE and RegCtb = @RegCtb
						select @Total= @Total+isnull(sum(Costo),0), @Total_ME=@Total_ME+ isnull(sum(Costo_ME),0) from CptoCostoOF where Ruce = @RucE and Cd_OF = @Cd_OF
						
						update Inventario set CosUnt = @Total / Cant,CosUnt_ME = @Total_ME/Cant, Total = @Total, Total_ME = @Total_ME where RucE = @RucE and Cd_Inv = @Cd_Inv
					end					
				end
				else -- es cambio o traslado
				begin
					if (@SalCant = 1)
					begin
						if exists (select * from Inventario where RucE = @RucE and RegCtb = @RegCtb and Cd_TO = '11' and IC_ES= 'S' and CosUnt <> 0 and CosUnt_ME <> 0)
						begin
							select @CosUnt = CosUnt, @CosUnt_ME = CosUnt_ME from Inventario where RucE = @RucE and RegCtb = @RegCtb and IC_ES= 'S'
							update Inventario set CosUnt = @CosUnt,CosUnt_ME = @CosUnt_ME, Total = Cant * @CosUnt, Total_ME = Cant * @CosUnt_ME where RucE = @RucE and Cd_Inv = @Cd_Inv
						end
					end
					else --muchos
					begin
						if exists (select * from Inventario where RucE = @RucE and RegCtb = @RegCtb and Cd_TO = '11' and IC_ES= 'S' and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and CosUnt <> 0 and CosUnt_ME <> 0)
						begin
							select @CosUnt = CosUnt, @CosUnt_ME = CosUnt_ME from Inventario where RucE = @RucE and RegCtb = @RegCtb and IC_ES= 'S'and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
							update Inventario set CosUnt = @CosUnt,CosUnt_ME = @CosUnt_ME, Total = Cant * @CosUnt, Total_ME = Cant * @CosUnt_ME where RucE = @RucE and Cd_Inv = @Cd_Inv
						end
					end
				end
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
