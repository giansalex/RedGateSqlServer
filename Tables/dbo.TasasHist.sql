CREATE TABLE [dbo].[TasasHist]
(
[Cd_Ts] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[EjerPrdoVig] [nchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Porc] [numeric] (6, 3) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TasasHist] ADD CONSTRAINT [FK__TasaHist_Tasa] FOREIGN KEY ([Cd_Ts]) REFERENCES [dbo].[Tasas] ([Cd_Ts])
GO
