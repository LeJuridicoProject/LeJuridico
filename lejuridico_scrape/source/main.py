import uvicorn
from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, JSONResponse  # Import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
from source.controller.processos import get_processo_info_by_id
from source.controller import processos
from fastapi.responses import JSONResponse
from source.models.Movimentacao import Movimentacao


app = FastAPI()



app.add_middleware(
    CORSMiddleware,
    allow_origins= ["*"],  # Allow specified origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

app.include_router(processos.router)

def get_jinja_templates():
    app.mount("/static", StaticFiles(directory="front-end/static"), name="static")
    app.mount("/templates", StaticFiles(directory="front-end/templates"), name="templates")
    return Jinja2Templates(directory="front-end/templates")


@app.get('/', response_class=HTMLResponse, tags=["home"], include_in_schema=False)
def main(request: Request):
    return get_jinja_templates().TemplateResponse('home.html', {'request': request})

@app.post('/buscaprocesso', include_in_schema=False)
def buscar_processo_pelo_form(request: Request, numero_processo: str = Form()):
    # Exemplo de retorno com .dict() para garantir que o objeto seja serializável
    try:
        result = get_processo_info_by_id(numero_processo)
        
        if result is None:
            return JSONResponse(status_code=404, content={"error": "Processo não encontrado"})
        
        # Se result contém objetos Movimentacao, use .dict() para cada Movimentacao
        if isinstance(result, Movimentacao):
            result = result.dict()  # Converte Movimentacao para um dicionário
        
        return JSONResponse(content={"result": result})
    
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": f"Ocorreu um erro: {str(e)}"})

if __name__ == "__main__":
    uvicorn.run("main:app", reload=True)
